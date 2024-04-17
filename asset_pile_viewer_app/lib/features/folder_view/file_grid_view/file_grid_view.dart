import 'dart:math';

import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:assetPileViewer/common/widgets/audioplayer/playlist_toggle_button.dart';
import 'package:assetPileViewer/common/widgets/selected_widget_controller.dart';
import 'package:assetPileViewer/features/folder_view/file_grid_view/file_grid_tile.dart';
import 'package:assetPileViewer/features/folder_view/file_grid_view/sort_order_toggle_button.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_root_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/filtered_file_list_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_file_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_folder_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _gridCrossAxisCount = 4;
const _pageSize = _gridCrossAxisCount * 6;

class FileGridView extends ConsumerStatefulWidget {
  final AudioPlayer audioPlayer;
  const FileGridView({super.key, required this.audioPlayer});

  @override
  ConsumerState<FileGridView> createState() => _FileGridViewState();
}

class _FileGridViewState extends ConsumerState<FileGridView> {
  final _selectedTileController = SelectedWidgetController();
  final _scrollController = ScrollController(initialScrollOffset: 5);
  int _pageCount = 1;
  int? _prevFileListHashCode;

  @override
  void initState() {
    final selectedFile = ref.read(selectedFileProvider);
    if (selectedFile.isNotEmpty) {
      _selectedTileController.changeWithKey(Key(selectedFile), true);
    }
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _selectedTileController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedFileProvider, (previous, next) {
      _selectedTileController.changeWithKey(Key(next), true);
    });

    final fileList = ref.watch(filteredFileListProvider);
    final assetRootFolder = ref.watch(assetRootFolderProvider);
    final selectedFolder = ref.watch(selectedFolderProvider);
    final folderString = _getFolderString(assetRootFolder, selectedFolder);

    //reset scroll if file list is different from before
    if (_prevFileListHashCode != fileList.hashCode) {
      _prevFileListHashCode = fileList.hashCode;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }

    return Flex(
      direction: Axis.vertical,
      children: [
        //header
        Padding(
          padding: const EdgeInsets.all(8.0),
          //header
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                folderString,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const PlayListToggleButton(),
              const SortOrderToggleButton(),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          flex: 1,
          child: GridView.builder(
            controller: _scrollController,
            itemCount: min(fileList.length, _pageCount * _pageSize),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _gridCrossAxisCount,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return FileGridTile(
                key: ValueKey(fileList[index].path),
                fileList[index],
                widget.audioPlayer,
                controller: _selectedTileController,
              );
            },
          ),
        ),
      ],
    );
  }

  String _getFolderString(String assetRootFolder, String selectedFolder) {
    String folderString = selectedFolder;
    final rootFolder = assetRootFolder.justPath();
    if (folderString.isEmpty) {
      folderString = '';
    } else if (folderString != rootFolder) {
      folderString =
          'Showing files for: ${folderString.substring(rootFolder.length + 1)}';
    } else {
      folderString = '/$rootFolder.lastDirectoryName()';
    }
    return folderString;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _pageCount++;
      });
    }
  }
}
