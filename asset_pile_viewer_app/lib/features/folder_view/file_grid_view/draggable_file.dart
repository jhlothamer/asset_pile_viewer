import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:flutter/material.dart';

class DraggableFile extends StatefulWidget {
  final String filePath;
  const DraggableFile({super.key, required this.filePath});

  @override
  State<DraggableFile> createState() => _DraggableFileState();
}

class _DraggableFileState extends State<DraggableFile> {
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: widget.filePath,
      feedback: Text(
        widget.filePath.fileName(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      childWhenDragging: const Icon(
        Icons.format_list_bulleted_add,
        size: 30,
      ),
      child: const Tooltip(
        message: 'Click and drag to list to add',
        child: Icon(Icons.format_list_bulleted),
      ),
    );
  }
}
