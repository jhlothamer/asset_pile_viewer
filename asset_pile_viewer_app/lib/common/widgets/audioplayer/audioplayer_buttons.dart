import 'dart:async';

import 'package:assetPileViewer/features/folder_view/providers/audio_playlist_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/playlist_toggle_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Repeat {
  off,
  one,
  all,
}

class AudioPlayerButtons extends ConsumerStatefulWidget {
  final AudioPlayer player;
  final double iconSize;
  const AudioPlayerButtons(
      {super.key, required this.player, this.iconSize = 32});

  @override
  ConsumerState<AudioPlayerButtons> createState() => _AudioPlayerButtonsState();
}

class _AudioPlayerButtonsState extends ConsumerState<AudioPlayerButtons> {
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;
  String _cachedSrcFilePath = '';
  Repeat repeat = Repeat.off;
  bool _prevPlayListOn = false;

  AudioPlayer get player => widget.player;
  double get iconSize => widget.iconSize;
  bool get _isPlaying => player.state == PlayerState.playing;
  bool get _isPaused => player.state == PlayerState.paused;

  String get _srcFilePath {
    if (player.source == null || player.source is! DeviceFileSource) {
      return _cachedSrcFilePath;
    }

    final fileSource = player.source as DeviceFileSource;
    _cachedSrcFilePath = fileSource.path;
    return _cachedSrcFilePath;
  }

  @override
  void initState() {
    _playerCompleteSubscription =
        player.onPlayerComplete.listen(_onPlayerCompleted);

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        if (player.source == null || player.source is! DeviceFileSource) {
          return;
        }

        final fileSource = player.source as DeviceFileSource;
        _cachedSrcFilePath = fileSource.path;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playListOn = ref.watch(playListToggleProvider);

    if (playListOn && !_prevPlayListOn && player.state != PlayerState.playing) {
      _startPlayList();
    }
    _prevPlayListOn = playListOn;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: const Key('play_button'),
          onPressed: _isPlaying || _srcFilePath.isEmpty ? null : _play,
          iconSize: iconSize,
          icon: const Icon(Icons.play_arrow),
        ),
        IconButton(
          key: const Key('pause_button'),
          onPressed: _isPlaying ? _pause : null,
          iconSize: iconSize,
          icon: const Icon(Icons.pause),
        ),
        IconButton(
          key: const Key('stop_button'),
          onPressed: _isPlaying || _isPaused ? _stop : null,
          iconSize: iconSize,
          icon: const Icon(Icons.stop),
        ),
        IconButton(
          tooltip: 'Toggle repeat one, all, off (currently ${repeat.name})',
          onPressed: () {
            setState(() {
              repeat = switch (repeat) {
                Repeat.off => Repeat.one,
                Repeat.one => Repeat.all,
                Repeat.all => Repeat.off,
              };
            });
          },
          icon: switch (repeat) {
            Repeat.off => const Icon(Icons.repeat),
            Repeat.one => const Icon(Icons.repeat_one_on_rounded),
            Repeat.all => const Icon(Icons.repeat_on),
          },
        ),
      ],
    );
  }

  Future<void> _play([String? filePath]) async {
    if (player.source == null) {
      if (_cachedSrcFilePath.isEmpty &&
          (filePath == null || filePath.isEmpty)) {
        debugPrint('no source and no cached file path');
        return;
      }
      player.play(DeviceFileSource(filePath ?? _cachedSrcFilePath));
    }
    await player.resume();
  }

  Future<void> _pause() async {
    await player.pause();
  }

  Future<void> _stop() async {
    await player.stop();
  }

  void _onPlayerCompleted(void event) {
    if (repeat == Repeat.one) {
      _play();
      return;
    }

    final playList = ref.read(audioPlayListProvider);
    if (playList.isNotEmpty) {
      final index = playList.indexOf(_cachedSrcFilePath);
      if (index < 0) {
        _play(playList[0]);
        return;
      }
      if ((index + 1) < playList.length) {
        _play(playList[index + 1]);
        return;
      }
      if (repeat == Repeat.all) {
        _play(playList[0]);
      }
      return;
    }

    if (repeat == Repeat.off) {
      return;
    }
    //Repeat.all - same as Repeat.one when no play list
    _play();
    return;
  }

  void _startPlayList() {
    final playList = ref.read(audioPlayListProvider);
    if (playList.isEmpty) {
      return;
    }
    _play(playList[0]);
  }
}
