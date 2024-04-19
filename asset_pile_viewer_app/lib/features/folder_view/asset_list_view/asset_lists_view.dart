import 'package:assetPileViewer/features/folder_view/providers/asset_lists_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetListsView extends ConsumerStatefulWidget {
  const AssetListsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AssetListViewState();
}

class _AssetListViewState extends ConsumerState<AssetListsView> {
  final _newListTextEditingController = TextEditingController();
  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final assetLists = ref.watch(assetListsProvider);
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _newListTextEditingController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'New list ',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (listName) {
                final trimmedListName = listName.trim();
                if (trimmedListName.isEmpty) {
                  return;
                }
                ref.read(assetListsProvider.notifier).addList(trimmedListName);
                _newListTextEditingController.clear();
                _focusNode.requestFocus();
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(assetLists[index].name),
              );
            },
            itemCount: assetLists.length,
          ),
        ),
      ],
    );
  }
}
