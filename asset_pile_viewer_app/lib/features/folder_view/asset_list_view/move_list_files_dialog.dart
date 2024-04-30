import 'package:assetPileViewer/features/folder_view/providers/asset_lists_provider.dart';
import 'package:assetPileViewer/models/asset_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showMoveListFilesDialog(
    BuildContext context, AssetList list) async {
  await showDialog(
    context: context,
    builder: (context) => MoveListFilesDialog(list: list),
  );
}

class MoveListFilesDialog extends ConsumerStatefulWidget {
  final AssetList list;
  const MoveListFilesDialog({super.key, required this.list});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MoveListFilesDialogState();
}

class _MoveListFilesDialogState extends ConsumerState<MoveListFilesDialog> {
  int? selectedListId;

  @override
  Widget build(BuildContext context) {
    final assetLists =
        ref.read(assetListsProvider).where((l) => l.id != widget.list.id);
    return AlertDialog(
      title: Text('Move File from List "${widget.list.name}"'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<int>(
          hint: const Text('Select list to move files to'),
          autofocus: true,
          value: selectedListId,
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              selectedListId = value ?? -1;
            });
          },
          items: [
            ...assetLists
                .map((l) => DropdownMenuItem(value: l.id, child: Text(l.name))),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (selectedListId == null || selectedListId! < 0) {
              return;
            }
            ref
                .read(assetListsProvider.notifier)
                .moveListFiles(widget.list.id, selectedListId!);
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
