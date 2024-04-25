import 'package:assetPileViewer/common/util/path.dart';
import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:assetPileViewer/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FileInfo {
  final String path;
  final String name;
  final FileType fileType;
  FileInfo(this.path, this.name, this.fileType);
  factory FileInfo.fromPath(String path) =>
      FileInfo(path, path.fileName(), path.getFileType());
}

class DirectoryNode {
  late String name;
  final DirectoryNode? parent;
  final children = <String, DirectoryNode>{};
  final _sortedChildren = <DirectoryNode>[];
  final files = <FileInfo>[];
  String diskPath;
  String treePath;
  int diskPathLength;
  DirectoryNode(this.name,
      {required this.diskPath,
      required this.treePath,
      required this.diskPathLength,
      this.parent});

  factory DirectoryNode.root(String path) {
    final parts = path.split(pathSeparator);
    final diskPathIndex = parts.length - 1;
    final name = parts[diskPathIndex];
    return DirectoryNode(name,
        diskPath: path, treePath: name, diskPathLength: diskPathIndex + 1);
  }

  factory DirectoryNode._child(List<String> pathParts, int diskPathIndex,
      int rootIndex, DirectoryNode parent) {
    final diskPath =
        pathParts.sublist(0, diskPathIndex + 1).join(pathSeparator);
    final treePath =
        pathParts.sublist(rootIndex, diskPathIndex + 1).join(pathSeparator);
    final name = pathParts[diskPathIndex];

    return DirectoryNode(name,
        diskPath: diskPath,
        treePath: treePath,
        diskPathLength: diskPathIndex + 1,
        parent: parent);
  }

  void addDirectory(String diskPath) {
    final pathParts = diskPath.split(pathSeparator);
    final index = diskPathLength;
    _add(pathParts, index, index - 1, true);
  }

  void addFile(String diskPath) {
    final pathParts = diskPath.split(pathSeparator);
    final index = diskPathLength;
    _add(pathParts, index, index - 1, false);
  }

  void _add(
      List<String> pathParts, int index, int rootIndex, bool addDirectory) {
    final lengthIndexDiff = pathParts.length - index;

    //if adding file, stop on last index
    if (!addDirectory && lengthIndexDiff == 1) {
      files.add(FileInfo(pathParts.join(pathSeparator), pathParts.last,
          pathParts.last.getFileType()));
      return;
    }
    //if beyond last index, stop
    if (lengthIndexDiff == 0) {
      return;
    }

    final childName = pathParts[index];
    var child = children[childName];
    if (child == null) {
      child = DirectoryNode._child(pathParts, index, rootIndex, this);
      children[childName] = child;
    }
    child._add(pathParts, index + 1, rootIndex, addDirectory);
  }

  void printTree([int indent = 0]) {
    final tabs = '\t' * indent;
    debugPrint('$tabs/$name ($diskPath)');
    for (final file in files) {
      debugPrint('$tabs\t${file.name} ($file)');
    }
    for (final dirChild in children.values) {
      dirChild.printTree(indent + 1);
    }
  }

  List<FileInfo> collectFiles(
      Map<String, AssetDirectory> assetdirectories,
      Map<String, AssetFile> assetfiles,
      Map<String, Set<String>> collectedFileKeywords,
      Set<String> accumulatedDirKeywords,
      bool showHidden) {
    final collectedFiles = <FileInfo>[];

    final assetDirectory = assetdirectories[diskPath];

    if (!showHidden && assetDirectory != null && assetDirectory.hidden) {
      return collectedFiles;
    }

    collectedFiles.addAll(files);

    if (assetDirectory != null && assetDirectory.keywords.isNotEmpty) {
      final keywords = assetDirectory.keywords.map((e) => e.name).toList();
      accumulatedDirKeywords = Set.from(accumulatedDirKeywords);
      accumulatedDirKeywords.addAll(keywords);
    }

    for (final fileInfo in files) {
      collectedFileKeywords[fileInfo.path] = Set.from(accumulatedDirKeywords);
      if (assetfiles.containsKey(fileInfo.path)) {
        final keywords =
            assetfiles[fileInfo.path]!.keywords.map((e) => e.name).toList();
        collectedFileKeywords[fileInfo.path]!.addAll(keywords);
      }
    }

    for (final child in children.values) {
      collectedFiles.addAll(child.collectFiles(assetdirectories, assetfiles,
          collectedFileKeywords, accumulatedDirKeywords, showHidden));
    }

    return collectedFiles;
  }

  DirectoryNode? getDirectoryNode(List<String> pathParts) {
    if (pathParts.isEmpty) {
      return this;
    }
    final childDirName = pathParts.first;
    if (!children.containsKey(childDirName)) {
      return null;
    }
    final child = children[childDirName]!;
    return child.getDirectoryNode(pathParts.sublist(1));
  }

  Set<String> getInheritedKeywords(
      Map<String, AssetDirectory> assetDirectories) {
    Set<String> inheritedDirKeywords = <String>{};

    DirectoryNode? node = this;

    while (node != null) {
      final assetDirectory = assetDirectories[node.diskPath];
      if (assetDirectory != null && assetDirectory.keywords.isNotEmpty) {
        final keywords = assetDirectory.keywords.map((e) => e.name).toList();
        inheritedDirKeywords.addAll(keywords);
      }

      node = node.parent;
    }

    return inheritedDirKeywords;
  }

  List<DirectoryNode> getSortedChildren() {
    if (children.isEmpty || _sortedChildren.isNotEmpty) {
      return _sortedChildren;
    }
    _sortedChildren.addAll(children.values);
    _sortedChildren.sort((a, b) => a.name.compareTo(b.name));
    return _sortedChildren;
  }
}
