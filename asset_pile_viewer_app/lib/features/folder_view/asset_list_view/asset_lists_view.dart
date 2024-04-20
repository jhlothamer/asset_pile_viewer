import 'package:assetPileViewer/common/widgets/selected_widget_controller.dart';
import 'package:assetPileViewer/features/folder_view/asset_list_view/asset_list_tile.dart';
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
  final _selectedWidgetController = SelectedWidgetController();
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return AssetListTile(
                    key: Key(assetLists[index].id.toString()),
                    assetList: assetLists[index],
                    controller: _selectedWidgetController);
              },
              itemCount: assetLists.length,
            ),
          ),
        ),
      ],
    );
  }
}
