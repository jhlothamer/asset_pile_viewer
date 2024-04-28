import 'dart:io';

import 'package:assetPileViewer/common/util/path.dart';
import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:assetPileViewer/common/widgets/confirm_dialog.dart';
import 'package:assetPileViewer/common/widgets/selected_widget_controller.dart';
import 'package:assetPileViewer/features/folder_view/asset_list_view/move_list_files.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_file_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_files_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_lists_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_asset_list_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/models.dart';

class AssetListTile extends ConsumerStatefulWidget {
  final AssetList assetList;
  final SelectedWidgetController controller;
  const AssetListTile(
      {super.key, required this.assetList, required this.controller});

  @override
  ConsumerState<AssetListTile> createState() => _AssetListTileState();
}

class _AssetListTileState extends ConsumerState<AssetListTile> {
  bool _selected = false;
  bool _hovered = false;
  @override
  void initState() {
    widget.controller.addListener(_selectedWidgetControllerChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_selectedWidgetControllerChanged);
    super.dispose();
  }

  void _selectedWidgetControllerChanged() {
    setState(() {
      _selected = widget.controller.has(widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = !_hovered
        ? []
        : [
            IconButton(
              tooltip: 'Edit Name',
              onPressed: () async {
                final newName =
                    await showRenameDialog(context, widget.assetList.name);
                if (newName == null || newName == widget.assetList.name) {
                  return;
                }
                if (!context.mounted) {
                  return;
                }
                if (!ref
                    .read(assetListsProvider.notifier)
                    .updateList(widget.assetList.copyWith(name: newName))) {
                  showConfirm(context,
                      title: 'List already exists.',
                      message:
                          'A list named $newName already exists.\r\n\r\nPlease choose a different name.',
                      onlyOk: true);
                }
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              tooltip: 'Copy Files to Folder',
              onPressed: () => _copyFilesToFolder(context),
              icon: const Icon(Icons.file_copy),
            ),
            IconButton(
              tooltip: 'Move Files to Another List',
              onPressed: () {
                showMoveListFilesDialog(context, widget.assetList);
              },
              icon: const Icon(Icons.logout),
            ),
            IconButton(
              tooltip: 'Delete List',
              onPressed: _deleteList,
              icon: const Icon(Icons.delete),
            ),
          ];

    return DragTarget(
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        final assetFile = ref.read(assetFileProvider(details.data));
        if (assetFile.lists.any((l) => l.id == widget.assetList.id)) {
          return;
        }
        ref.read(assetFilesProvider.notifier).updateLists(
            assetFile.path, [...assetFile.lists, widget.assetList]);
      },
      builder: (context, _, __) => InkWell(
        onTap: _toggleSelection,
        onHover: (value) {
          setState(() {
            _hovered = value;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            color: _selected ? Theme.of(context).focusColor : null,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.assetList.name} (${widget.assetList.fileCount})',
                      //style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                ...buttons,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSelection() {
    widget.controller.change(widget, !_selected);
    final notifier = ref.read(selectedAssetListProvider.notifier);
    if (_selected) {
      notifier.select(widget.assetList);
    } else {
      notifier.clear();
    }
  }

  void _copyFilesToFolder(BuildContext context) async {
    if (widget.assetList.fileCount == 0) {
      await showConfirm(context,
          title: 'No Files to Copy',
          message: 'The list "${widget.assetList.name}" has no files to copy.',
          onlyOk: true);
      return;
    }

    var destinationPath =
        await getDirectoryPath(confirmButtonText: 'Copy Files');
    if (destinationPath == null) {
      return;
    }
    if (!destinationPath.endsWith(pathSeparator)) {
      destinationPath += pathSeparator;
    }

    //check if any are going to be copied over
    var confirmOverwrite = false;
    final fromToPaths = <String, String>{};
    final filePaths = ref
        .read(assetFilesProvider)
        .values
        .where((f) => f.lists.any((l) => l.id == widget.assetList.id))
        .map((e) => e.path);
    for (String filePath in filePaths) {
      final file = File(filePath);
      if (!await file.exists()) {
        continue;
      }
      final copyToFilePath = '$destinationPath${filePath.fileName()}';
      final destFile = File(copyToFilePath);
      if (await destFile.exists()) {
        confirmOverwrite = true;
      }
      fromToPaths[filePath] = copyToFilePath;
    }

    if (confirmOverwrite) {
      if (!context.mounted) {
        return;
      }
      if (!await showConfirm(context,
          message:
              'Some files in the destination folder will be overwritten.  Is this OK?')) {
        return;
      }
    }

    fromToPaths.forEach((fromPath, toPath) async {
      await File(fromPath).copy(toPath);
    });

    if (!context.mounted) {
      return;
    }
    await showConfirm(context,
        title: 'Files Copied.',
        message: '${fromToPaths.length} file(s) copied.',
        onlyOk: true);
  }

  void _deleteList() async {
    final isEmpty = widget.assetList.fileCount == 0;
    if (isEmpty ||
        await showConfirm(context,
            title: 'Delete list "${widget.assetList.name}"?',
            message:
                'This list has ${widget.assetList.fileCount} file(s) in it.'
                '\r\nAre you sure you want to delete this list?')) {
      ref.read(assetListsProvider.notifier).deleteList(widget.assetList);
    }
  }

  Future<String?> showRenameDialog(BuildContext context, String name) async {
    final textEditingController = TextEditingController(text: name);
    final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Rename list $name'),
              content: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(labelText: 'Enter new name'),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(textEditingController.text);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
    return result;
  }
}
