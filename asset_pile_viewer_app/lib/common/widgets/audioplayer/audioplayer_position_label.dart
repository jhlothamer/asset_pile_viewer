import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerPositionLabel extends StatefulWidget {
  final AudioPlayer player;
  const AudioPlayerPositionLabel({super.key, required this.player});

  @override
  State<AudioPlayerPositionLabel> createState() =>
      _AudioPlayerPositionLabelState();
}

class _AudioPlayerPositionLabelState extends State<AudioPlayerPositionLabel> {
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  //StreamSubscription? _playerStateChangeSubscription;
  Duration? _duration;
  Duration? _position;

  AudioPlayer get player => widget.player;
  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';

  @override
  void initState() {
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
          }),
        );

    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() {
        _position = p;
      }),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _position != null
          ? '$_positionText / $_durationText'
          : _duration != null
              ? _durationText
              : '',
      style: const TextStyle(fontSize: 16.0),
    );
  }
}
