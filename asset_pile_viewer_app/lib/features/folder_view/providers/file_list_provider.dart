// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:assetPileViewer/common/util/path.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/directory_node.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_directories_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_files_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_root_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/directory_tree_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_asset_list_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/show_hidden_folders_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/sort_order_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_list_provider.g.dart';

class FileListInfo {
  List<FileInfo> files;
  Map<String, Set<String>> fileKeywords;
  FileListInfo({
    required this.files,
    required this.fileKeywords,
  });
  factory FileListInfo.empty() => FileListInfo(files: [], fileKeywords: {});
}

@riverpod
class FileList extends _$FileList {
  @override
  FileListInfo build() {
    final assetFiles = ref.watch(assetFilesProvider);
    final selectedAssetList = ref.watch(selectedAssetListProvider);

    if (selectedAssetList != null) {
      final fileKeywords = assetFiles.map((key, value) =>
          MapEntry(key, value.keywords.map((k) => k.name).toSet()));
      final files = assetFiles.values
          .where((f) => f.lists.any((l) => l.id == selectedAssetList.id))
          .map((f) => FileInfo.fromPath(f.path))
          .toList();
      return FileListInfo(files: files, fileKeywords: fileKeywords);
    }

    final selectedFolder = ref.watch(selectedFolderProvider);
    final assetRootFolder = ref.watch(assetRootFolderProvider);
    final result = ref.watch(directoryTreeProvider);

    if (result.value == null ||
        selectedFolder.isEmpty ||
        assetRootFolder.isEmpty) {
      return FileListInfo.empty();
    }

    final root = result.value!;

    final selectedNodePath = selectedFolder.substring(assetRootFolder.length);
    final pathParts = selectedNodePath.split(pathSeparator);
    pathParts.removeWhere((s) => s.isEmpty);

    final selectedNode = root.getDirectoryNode(pathParts);
    if (selectedNode == null) {
      return FileListInfo.empty();
    }

    final assetDirectories = ref.watch(assetDirectoriesProvider);
    final collectedFileKeywords = <String, Set<String>>{};

    final showHidden = ref.watch(showHiddenFoldersProvider);
    final inheritedKeywords =
        selectedNode.getInheritedKeywords(assetDirectories);

    final collectedFiles = selectedNode.collectFiles(assetDirectories,
        assetFiles, collectedFileKeywords, inheritedKeywords, showHidden);

    final sortOrder = ref.watch(sortOrderProvider);
    final sortFactor = sortOrder == SortDirection.ascending ? 1 : -1;

    collectedFiles.sort(
      (a, b) => a.name.compareTo(b.name) * sortFactor,
    );

    return FileListInfo(
        files: collectedFiles, fileKeywords: collectedFileKeywords);
  }
}
