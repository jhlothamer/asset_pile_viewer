import 'package:assetPileViewer/common/widgets/audioplayer_buttons.dart';
import 'package:assetPileViewer/common/widgets/audioplayer_nowplaying.dart';
import 'package:assetPileViewer/common/widgets/audioplayer_position_label.dart';
import 'package:assetPileViewer/common/widgets/audioplayer_scrub_ctrl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerControls extends StatelessWidget {
  final AudioPlayer player;
  final Axis direction;
  const AudioPlayerControls(
      {super.key, required this.player, this.direction = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Row(
        children: [
          AudioPlayerButtons(player: player),
          Expanded(
            child: Column(
              children: [
                AudioPlayerNowPlaying(player: player),
                AudioPlayerScrubCtrl(player: player),
                AudioPlayerPositionLabel(player: player),
              ],
            ),
          )
        ],
      );
    }

    return Column(
      children: [
        AudioPlayerButtons(player: player),
        AudioPlayerNowPlaying(player: player),
        AudioPlayerScrubCtrl(player: player),
        AudioPlayerPositionLabel(player: player),
      ],
    );
  }
}
