import 'dart:async';

import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerNowPlaying extends StatefulWidget {
  final AudioPlayer player;
  const AudioPlayerNowPlaying({super.key, required this.player});

  @override
  State<AudioPlayerNowPlaying> createState() => _AudioPlayerNowPlayingState();
}

class _AudioPlayerNowPlayingState extends State<AudioPlayerNowPlaying> {
  AudioPlayer get player => widget.player;
  StreamSubscription? _playerStateChangeSubscription;
  String _cachedSrcFilePath = '';
  String get _srcFileName {
    if (player.source == null || player.source is! DeviceFileSource) {
      return _cachedSrcFilePath.fileName();
    }

    final fileSource = player.source as DeviceFileSource;
    _cachedSrcFilePath = fileSource.path;
    return _cachedSrcFilePath.fileName();
  }

  @override
  void initState() {
    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_srcFileName);
  }
}
