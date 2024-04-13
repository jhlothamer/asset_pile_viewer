import 'package:assetPileViewer/common/widgets/audioplayer/audioplayer_controls.dart';
import 'package:assetPileViewer/features/about/about.dart';
import 'package:assetPileViewer/features/folder_view/file_filter/file_filter.dart';
import 'package:assetPileViewer/features/folder_view/file_grid_view/file_grid_view.dart';
import 'package:assetPileViewer/features/folder_view/file_details/file_detail_display.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/folder_view.dart';
import 'package:assetPileViewer/features/folder_view/settings_menu.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';

class FolderViewPage extends StatefulWidget {
  const FolderViewPage({super.key});

  @override
  State<FolderViewPage> createState() => _FolderViewPageState();
}

class _FolderViewPageState extends State<FolderViewPage> {
  final _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SplitView(
            indicator: SplitIndicator(
              isActive: true,
              viewMode: SplitViewMode.Horizontal,
              color: Theme.of(context).colorScheme.background,
            ),
            controller: SplitViewController(
              weights: [.3, null],
              limits: [WeightLimit(min: .2, max: .6), null],
            ),
            viewMode: SplitViewMode.Horizontal,
            children: [
              const FolderView(),
              Flex(
                direction: Axis.vertical,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 40),
                    child: FileFilter(),
                  ),
                  const Divider(),
                  AudioPlayerControls(
                    player: _audioPlayer,
                  ),
                  const Divider(
                    height: 4,
                  ),
                  //grid view and details
                  Expanded(
                    child: SplitView(
                        indicator: SplitIndicator(
                          isActive: true,
                          viewMode: SplitViewMode.Horizontal,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        viewMode: SplitViewMode.Horizontal,
                        controller: SplitViewController(
                          weights: [.6, null],
                          limits: [WeightLimit(min: .4, max: .8)],
                        ),
                        children: [
                          FileGridView(
                            audioPlayer: _audioPlayer,
                          ),
                          const FileDetailDisplay(),
                        ]),
                  )
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            child: const SettingsMenu(),
          )
        ],
      ),
    );
  }
}
