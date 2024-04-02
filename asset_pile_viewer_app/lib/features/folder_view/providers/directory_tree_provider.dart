import 'dart:io';

import 'package:assetPileViewer/common/supported_file_formats.dart';
import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/directory_node.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_root_folder_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'directory_tree_provider.g.dart';

@riverpod
class DirectoryTree extends _$DirectoryTree {
  @override
  FutureOr<DirectoryNode> build() async {
    final rootPath = ref.watch(assetRootFolderProvider);
    final DirectoryNode rootNode = DirectoryNode.root(rootPath);

    final rootDir = Directory(rootPath);

    if (rootPath.isEmpty) {
      return rootNode;
    }

    await rootDir.list(recursive: true).listen((fsEntity) {
      if (fsEntity.path.contains('_MACOSX') || fsEntity.path.contains('._')) {
        return;
      }
      if (fsEntity is Directory) {
        rootNode.addDirectory(fsEntity.path);
      } else {
        final extension = fsEntity.path.extension();
        if (supportedExtensions.contains(',$extension,')) {
          rootNode.addFile(fsEntity.path);
        }
      }
    }).asFuture();

    return rootNode;
  }
}
