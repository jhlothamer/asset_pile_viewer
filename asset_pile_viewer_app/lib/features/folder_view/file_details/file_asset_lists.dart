import 'package:assetPileViewer/features/folder_view/providers/asset_files_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_lists_provider.dart';
import 'package:assetPileViewer/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _iconButtonSize = 20.0;

class FileAssetLists extends ConsumerStatefulWidget {
  final AssetFile assetFile;
  const FileAssetLists({super.key, required this.assetFile});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FileAssetListsState();
}

class _FileAssetListsState extends ConsumerState<FileAssetLists> {
  var _editing = false;
  var _selectedListIds = <int>[];

  @override
  void initState() {
    _selectedListIds = widget.assetFile.lists.map((l) => l.id).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final assetLists = ref.watch(assetListsProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 40, top: 8),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    ..._editing
                        ? assetLists.map(
                            (l) => ChoiceChip(
                              label: Text(l.name),
                              selected: _selectedListIds
                                  .any((listId) => listId == l.id),
                              onSelected: (selected) {
                                setState(() {
                                  if (!selected) {
                                    _selectedListIds.remove(l.id);
                                  } else {
                                    _selectedListIds.add(l.id);
                                  }
                                });
                              },
                            ),
                          )
                        : widget.assetFile.lists.map(
                            (l) => InputChip(
                              label: Text(l.name),
                              padding: EdgeInsets.zero,
                              backgroundColor: Theme.of(context).focusColor,
                              side: BorderSide.none,
                              deleteButtonTooltipMessage:
                                  'Remove List ${l.name}',
                              onDeleted: () {
                                final updatedLists = widget.assetFile.lists
                                    .where((element) => element.id != l.id)
                                    .toList();
                                ref
                                    .read(assetFilesProvider.notifier)
                                    .updateLists(
                                        widget.assetFile.path, updatedLists);
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: _editing
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check),
                      iconSize: _iconButtonSize,
                      visualDensity: VisualDensity.compact,
                      color: Colors.green,
                      onPressed: () {
                        final updatedLists = assetLists
                            .where((assetList) => _selectedListIds.any(
                                (selectedListId) =>
                                    selectedListId == assetList.id))
                            .toList();
                        ref
                            .read(assetFilesProvider.notifier)
                            .updateLists(widget.assetFile.path, updatedLists);

                        setState(() {
                          _editing = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: _iconButtonSize,
                      visualDensity: VisualDensity.compact,
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          _editing = false;
                        });
                      },
                    ),
                  ],
                )
              : IconButton(
                  tooltip: 'Edit Lists',
                  icon: const Icon(Icons.edit),
                  iconSize: _iconButtonSize,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(() {
                      _selectedListIds =
                          widget.assetFile.lists.map((l) => l.id).toList();
                      _editing = true;
                    });
                  },
                ),
        )
      ],
    );
  }
}
