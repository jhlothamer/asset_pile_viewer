import 'package:assetPileViewer/common/util/path.dart';
import 'package:assetPileViewer/common/widgets/selected_widget_controller.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/directory_node.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/folder_view_header.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_directories_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_root_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/directory_tree_provider.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/folder_view_tile.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/show_hidden_folders_provider.dart';
import 'package:assetPileViewer/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class FolderView extends ConsumerStatefulWidget {
  const FolderView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FolderViewState();
}

class _FolderViewState extends ConsumerState<FolderView> {
  TreeController<DirectoryNode>? _treeController;
  final SelectedWidgetController _tileController = SelectedWidgetController();
  Map<String, AssetDirectory>? assetDirectories;
  bool showHidden = false;

  @override
  void initState() {
    final selectedFolder = ref.read(selectedFolderProvider);
    if (selectedFolder.isNotEmpty) {
      _tileController.changeWithKey(Key(selectedFolder), true);
    }

    super.initState();
  }

  @override
  void dispose() {
    _tileController.dispose();
    _treeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rootFolder = ref.watch(assetRootFolderProvider);
    final results = ref.watch(directoryTreeProvider);
    assetDirectories = ref.watch(assetDirectoriesProvider);
    showHidden = ref.watch(showHiddenFoldersProvider);

    return Column(
      children: [
        //header
        FolderViewHeader(onAssetRootFolderSelected: (rootFolder) {
          _tileController.changeWithKey(Key(rootFolder), true);
        }),
        Expanded(
          child: results.when(
            data: (data) {
              if (rootFolder.isEmpty) {
                return const Center(
                  child: Text('Please select an asset folder'),
                );
              }
              _initTreeController(rootFolder, data);
              return _createTree();
            },
            error: (error, _) => Center(
              child: Text(
                error.toString(),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _createTree() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TreeView(
        treeController: _treeController!,
        nodeBuilder: _buildNode,
      ),
    );
  }

  void _initTreeController(String rootFolder, DirectoryNode root) {
    _treeController?.dispose();
    _treeController = TreeController(
      roots: [root],
      childrenProvider: _getChildren,
      parentProvider: (node) => node.parent,
    );

    //expand tree to selected folder if possible (expand all otherwise)
    final selectedFolder = ref.read(selectedFolderProvider);

    if (selectedFolder.isEmpty) {
      _treeController?.expandAll();
      return;
    }

    final expandNodePath = selectedFolder.isNotEmpty
        ? selectedFolder.substring(rootFolder.length)
        : '';
    final pathParts = expandNodePath.split(pathSeparator);
    pathParts.removeWhere((part) => part.isEmpty);
    final expandDirNode = root.getDirectoryNode(pathParts);

    if (expandDirNode == null) {
      _treeController?.expandAll();
      return;
    }

    _treeController?.expandAncestors(expandDirNode);
    _treeController?.expand(expandDirNode);
  }

  Iterable<DirectoryNode> _getChildren(DirectoryNode node) => showHidden
      ? node.getSortedChildren()
      : node
          .getSortedChildren()
          .where((c) => !(assetDirectories?[c.diskPath]?.hidden ?? false));

  bool _isNodeHidden(String path) {
    if (assetDirectories == null) {
      return false;
    }
    final hiddenDirectories =
        assetDirectories!.values.where((ad) => ad.hidden).map((e) => e.path);

    for (final hiddenDirectory in hiddenDirectories) {
      if (path.startsWith(hiddenDirectory)) {
        return true;
      }
    }

    return false;
  }

  Widget _buildNode(BuildContext context, TreeEntry<DirectoryNode> entry) {
    return FolderViewTile(
      key: Key(entry.node.diskPath),
      hidden: _isNodeHidden(entry.node.diskPath),
      controller: _tileController,
      entry: entry,
      onTap: () {
        _treeController!.toggleExpansion(entry.node);
      },
      onSelected: () {
        ref.read(selectedFolderProvider.notifier).update(entry.node.diskPath);
      },
      onHiddenChanged: (hidden) {
        ref
            .read(assetDirectoriesProvider.notifier)
            .updateHidden(entry.node.diskPath, hidden);
      },
    );
  }
}
