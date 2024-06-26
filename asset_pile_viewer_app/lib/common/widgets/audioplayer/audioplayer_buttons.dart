import 'dart:async';

import 'package:assetPileViewer/common/widgets/audioplayer/playlist_toggle_button.dart';
import 'package:assetPileViewer/features/folder_view/providers/audio_playlist_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/playlist_toggle_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_file_provider.dart';
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
          onPressed: !playListOn
              ? null
              : () {
                  _skip(-1);
                },
          iconSize: iconSize,
          icon: const Icon(Icons.skip_previous),
        ),
        IconButton(
          key: const Key('play_button'),
          onPressed: _srcFilePath.isEmpty
              ? null
              : _isPlaying
                  ? _pause
                  : _play,
          iconSize: iconSize,
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
        ),
        IconButton(
          key: const Key('stop_button'),
          onPressed: _isPlaying || _isPaused ? _stop : null,
          iconSize: iconSize,
          icon: const Icon(Icons.stop),
        ),
        IconButton(
          onPressed: !playListOn
              ? null
              : () {
                  _skip(1);
                },
          iconSize: iconSize,
          icon: const Icon(Icons.skip_next),
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
        const PlayListToggleButton(),
      ],
    );
  }

  Future<void> _play([String? filePath]) async {
    if (player.source == null) {
      if (_cachedSrcFilePath.isEmpty &&
          (filePath == null || filePath.isEmpty)) {
        return;
      }
      player.play(DeviceFileSource(filePath ?? _cachedSrcFilePath));
      ref
          .read(selectedFileProvider.notifier)
          .update(filePath ?? _cachedSrcFilePath);
      return;
    }
    if (filePath != null) {
      final source = player.source as DeviceFileSource;
      if (source.path != filePath) {
        player.play(DeviceFileSource(filePath));
        ref.read(selectedFileProvider.notifier).update(filePath);
        return;
      }
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
    Future.delayed(Duration.zero, () {
      final playList = ref.read(audioPlayListProvider);
      if (playList.isEmpty) {
        return;
      }
      _play(playList[0]);
    });
  }

  void _skip(int direction) {
    final playList = ref.read(audioPlayListProvider);
    if (playList.isEmpty) {
      //nothing to skip to
      return;
    }
    final index = playList.indexOf(_cachedSrcFilePath) + direction;
    if (index >= 0 && index < playList.length) {
      //skip to index valid
      _play(playList[index]);
      return;
    }
    if (repeat != Repeat.all) {
      //only wrap to first/last on skip if repeat is all
      return;
    }
    if (index < 0) {
      //skip to last from first
      _play(playList.last);
      return;
    }
    //skip to first from last
    _play(playList.first);
  }
}
