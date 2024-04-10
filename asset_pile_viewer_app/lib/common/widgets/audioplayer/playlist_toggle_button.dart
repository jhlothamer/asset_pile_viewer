import 'package:assetPileViewer/features/folder_view/providers/playlist_toggle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayListToggleButton extends ConsumerWidget {
  const PlayListToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playListOn = ref.watch(playListToggleProvider);
    return IconButton(
      onPressed: () {
        ref.read(playListToggleProvider.notifier).toggle();
      },
      icon: Icon(
        playListOn ? Icons.playlist_remove : Icons.playlist_play,
      ),
      tooltip:
          'Toggle PlayList on, off (currently ${playListOn ? 'on' : 'off'})',
    );
  }
}
