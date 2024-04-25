import 'package:assetPileViewer/features/folder_view/providers/asset_root_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_file_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/show_hidden_folders_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FolderViewHeader extends ConsumerWidget {
  final void Function(String) onAssetRootFolderSelected;
  const FolderViewHeader({super.key, required this.onAssetRootFolderSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootFolder = ref.watch(assetRootFolderProvider);
    final showHidden = ref.watch(showHiddenFoldersProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selected asset folder:',
              style: Theme.of(context).textTheme.labelSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  rootFolder.isEmpty
                      ? 'Please select an asset folder'
                      : rootFolder,
                ),
              ),
              MenuAnchor(
                menuChildren: [
                  MenuItemButton(
                    child: const Text('Change Folder'),
                    onPressed: () async {
                      final directoryPath =
                          (await getDirectoryPath(initialDirectory: rootFolder))
                              ?.trim();

                      if (directoryPath == null || directoryPath.isEmpty) {
                        return;
                      }
                      ref
                          .read(assetRootFolderProvider.notifier)
                          .update(directoryPath);
                      ref
                          .read(selectedFolderProvider.notifier)
                          .update(directoryPath);
                      ref.read(selectedFileProvider.notifier).clear();
                      onAssetRootFolderSelected(directoryPath);
                    },
                  ),
                  MenuItemButton(
                    child: Text(showHidden ? 'Hide Hidden' : 'Show Hidden'),
                    onPressed: () {
                      ref
                          .read(showHiddenFoldersProvider.notifier)
                          .update(!showHidden);
                    },
                  ),
                ],
                builder: (context, controller, child) {
                  return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.more_horiz));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
