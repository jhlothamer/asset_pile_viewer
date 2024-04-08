import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
      setState(() {});
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {});
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
      ],
    );
  }

  Future<void> _play() async {
    if (player.source == null) {
      if (_cachedSrcFilePath.isEmpty) {
        return;
      }
      player.play(DeviceFileSource(_cachedSrcFilePath));
    }
    await player.resume();
    // setState(() {
    //   //_playerState = PlayerState.playing;
    // });
  }

  Future<void> _pause() async {
    await player.pause();
    //setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    // setState(() {
    //   _playerState = PlayerState.stopped;
    //   _position = Duration.zero;
    // });
  }
}
