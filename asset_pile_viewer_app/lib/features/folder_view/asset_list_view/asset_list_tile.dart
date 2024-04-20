import 'package:assetPileViewer/common/widgets/confirm_dialog.dart';
import 'package:assetPileViewer/common/widgets/selected_widget_controller.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_lists_provider.dart';
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
    return InkWell(
      onTap: () {
        widget.controller.change(widget, true);
      },
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
                    widget.assetList.name,
                    //style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              if (_hovered)
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
              if (_hovered)
                IconButton(
                  tooltip: 'Delete',
                  onPressed: () async {
                    if (await showConfirm(context,
                        title: 'Delete list ${widget.assetList.name}?',
                        message:
                            'Are you sure you want to delete list ${widget.assetList.name}?')) {
                      ref
                          .read(assetListsProvider.notifier)
                          .deleteList(widget.assetList);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),
        ),
      ),
    );
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
