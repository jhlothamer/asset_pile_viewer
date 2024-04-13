import 'dart:async';

import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:assetPileViewer/common/widgets/images.dart';
import 'package:assetPileViewer/common/widgets/selected_widget_controller.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/directory_node.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_file_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileGridTile extends ConsumerStatefulWidget {
  final FileInfo fileInfo;
  final AudioPlayer audioPlayer;
  final SelectedWidgetController? controller;
  const FileGridTile(this.fileInfo, this.audioPlayer,
      {super.key, this.controller});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FileGridTileState();
}

class _FileGridTileState extends ConsumerState<FileGridTile> {
  bool playing = false;
  bool selected = false;
  StreamSubscription<PlayerState>? _playerStateChangedSub;

  @override
  void initState() {
    final source = widget.audioPlayer.source as DeviceFileSource?;
    if (source != null) {
      playing = source.path == widget.fileInfo.path;
    }
    if (playing) {
      _playerStateChangedSub =
          widget.audioPlayer.onPlayerStateChanged.listen(_onPlayerStateChanged);
    }

    if (widget.controller != null) {
      widget.controller!.addListener(_onControllerChanged);
      if (widget.controller!.has(widget)) {
        selected = true;
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    if (_playerStateChangedSub != null) {
      _playerStateChangedSub?.cancel();
    }
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onPlayerStateChanged(event) {
    if (event == PlayerState.playing) {
      final currSrc = widget.audioPlayer.source as DeviceFileSource?;
      if (currSrc?.path == widget.fileInfo.path) {
        return;
      }
    }
    setState(() {
      playing = false;
    });
  }

  void _onControllerChanged() {
    final controllerHas = widget.controller!.has(widget);
    if (controllerHas == selected) {
      return;
    }
    setState(() {
      selected = controllerHas;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget inner = _createInner(context);

    return GestureDetector(
      onTap: _toggleSelected,
      child: GridTile(
        header: Tooltip(
          message: widget.fileInfo.name,
          child: GridTileBar(
            title: Container(
              color: Theme.of(context).colorScheme.inverseSurface,
              child: Text(
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.background),
                widget.fileInfo.name,
              ),
            ),
          ),
        ),
        child: Container(
          color: selected
              ? Theme.of(context).focusColor
              : Theme.of(context).colorScheme.background,
          child: inner,
        ),
      ),
    );
  }

  void _toggleSelected() {
    if (!selected) {
      ref.read(selectedFileProvider.notifier).update(widget.fileInfo.path);
    } else {
      ref.read(selectedFileProvider.notifier).clear();
    }
  }

  Widget _createInner(BuildContext context) {
    final fileType = widget.fileInfo.fileType;

    switch (fileType) {
      case FileType.texture:
        return _createTextureInner(context);
      case FileType.sound:
        return _createSoundInner();
      case _:
        return Center(
          child: Text('.${widget.fileInfo.name.extension()}'),
        );
    }
  }

  Widget _createTextureInner(BuildContext context) {
    return getImage(context, widget.fileInfo.path);
  }

  Widget _createSoundInner() {
    return Center(
      child: IconButton(
        splashRadius: 20,
        iconSize: 50,
        onPressed: () {
          //currently playing - stop
          if (playing) {
            widget.audioPlayer.stop();
            _playerStateChangedSub?.cancel();
            _playerStateChangedSub = null;
          } else {
            widget.audioPlayer.play(DeviceFileSource(widget.fileInfo.path));
            // listen for player state change
            _playerStateChangedSub ??= widget.audioPlayer.onPlayerStateChanged
                .listen(_onPlayerStateChanged);
          }

          setState(() {
            playing = !playing;
          });
          if (!selected) {
            _toggleSelected();
          }
        },
        icon: Icon(playing ? Icons.stop_circle : Icons.play_circle),
      ),
    );
  }
}
