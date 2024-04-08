import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum Repeat {
  off,
  one,
  all,
}

class AudioPlayerButtons extends StatefulWidget {
  final AudioPlayer player;
  final double iconSize;
  const AudioPlayerButtons(
      {super.key, required this.player, this.iconSize = 32});

  @override
  State<AudioPlayerButtons> createState() => _AudioPlayerButtonsState();
}

class _AudioPlayerButtonsState extends State<AudioPlayerButtons> {
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;
  String _cachedSrcFilePath = '';
  Repeat repeat = Repeat.off;

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
    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      // debugPrint('completed');
      // if (repeat == Repeat.one) {
      //   debugPrint('repeating');
      //   _play();
      // }
      setState(() {
        if (repeat == Repeat.one) {
          _play();
        }
      });
    });

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
          onPressed: () {
            setState(() {
              repeat = switch (repeat) {
                Repeat.off => Repeat.one,
                Repeat.one => Repeat.off,
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

  Future<void> _play() async {
    if (player.source == null) {
      if (_cachedSrcFilePath.isEmpty) {
        debugPrint('no source and no cached file path');
        return;
      }
      player.play(DeviceFileSource(_cachedSrcFilePath));
    }
    await player.resume();
  }

  Future<void> _pause() async {
    await player.pause();
  }

  Future<void> _stop() async {
    await player.stop();
  }
}
