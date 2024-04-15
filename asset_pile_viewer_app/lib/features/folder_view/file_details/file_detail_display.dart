import 'dart:io';

import 'package:assetPileViewer/common/providers/theme_provider.dart'
    as ThemeProvider;
import 'package:assetPileViewer/common/util/path.dart';
import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:assetPileViewer/common/widgets/images.dart';
import 'package:assetPileViewer/common/widgets/keyword_edit.dart';
import 'package:assetPileViewer/common/widgets/open_file_explorer_button.dart';
import 'package:assetPileViewer/features/folder_view/file_details/audio_file_details.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/directory_node.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_directories_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_files_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_root_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/directory_tree_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/keywords_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_file_provider.dart';
import 'package:assetPileViewer/models/models.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

class FileDetailDisplay extends ConsumerStatefulWidget {
  const FileDetailDisplay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FileDetailDisplayState();
}

class _FileDetailDisplayState extends ConsumerState<FileDetailDisplay> {
  @override
  Widget build(BuildContext context) {
    final assetRootFolder = ref.watch(assetRootFolderProvider);
    final selectedFilePath = ref.watch(selectedFileProvider);
    final rootNode = ref.watch(directoryTreeProvider).value;

    if (selectedFilePath.isEmpty) {
      return const Center(
        child: Text('Please select a file for details'),
      );
    }

    if (rootNode == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final fileType = selectedFilePath.getFileType();
    final fileName = selectedFilePath.fileName();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Selected File:',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Tooltip(
                  message: fileName,
                  child: Text(
                    fileName,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              OpenFileExplorerButton(path: selectedFilePath)
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._getDetails(selectedFilePath, assetRootFolder, rootNode),
                  if (fileType == FileType.texture)
                    ..._getTextureDetails(context, selectedFilePath),
                  if (fileType == FileType.sound)
                    ..._getSoundDetails(selectedFilePath),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getDetails(
      String selectedFilePath, String assetRootFolder, DirectoryNode rootNode) {
    final assetFile = ref.watch(assetFilesProvider)[selectedFilePath] ??
        AssetFile.newFile(selectedFilePath);
    final relativeFolderPath =
        selectedFilePath.replaceAll(assetRootFolder, '').justPath();

    final inheritedKeywords =
        _getInheritedKeywords(relativeFolderPath, rootNode).join(', ');

    return [
      Row(
        children: [
          Text(
            'In folder:',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
      Row(
        children: [
          Flexible(
            child: Tooltip(
              message: relativeFolderPath,
              child: Text(
                relativeFolderPath,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      const Divider(),
      const Row(
        children: [
          Text(
            'keywords:',
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      Row(
        children: [
          Text(
            'inherited: $inheritedKeywords',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
      KeywordEdit(
        controller: KeywordEditorController(
          assetFile.keywords.map((e) => e.name).toList(),
        ),
        onKeywordsAdded: (newKeywords) {
          final savedKeywords = ref.read(keywordsProvider.notifier).saveAll(
              newKeywords.map((e) => Keyword.newKeyword(name: e)).toList());
          final updatedKeywords = [...assetFile.keywords, ...savedKeywords];

          ref
              .read(assetFilesProvider.notifier)
              .updateKeywords(selectedFilePath, updatedKeywords);
        },
        onKeywordDeleted: (deletedKeyword) {
          final updatedKeywords = assetFile.keywords
              .where((k) => k.name != deletedKeyword)
              .toList();
          ref
              .read(assetFilesProvider.notifier)
              .updateKeywords(selectedFilePath, updatedKeywords);
          ref.read(keywordsProvider.notifier).purgeUnused();
        },
      ),
    ];
  }

  List<Widget> _getTextureDetails(
      BuildContext context, String selectedFilePath) {
    final isSvg = selectedFilePath.extension().toLowerCase() == 'svg';

    Size? size;
    Image? img;
    if (!isSvg) {
      try {
        final imageFile = File(selectedFilePath);
        size = ImageSizeGetter.getSize(FileInput(imageFile));
      } catch (e) {
        //ignore
      }
    }

    img = getImage(context, selectedFilePath);

    final currentTheme = ref.read(ThemeProvider.themeProvider);
    final imageViewerBackgroundColor =
        currentTheme == ThemeProvider.AppTheme.light
            ? Colors.white
            : Colors.black;

    return [
      const SizedBox(height: 8),
      const Divider(),
      GestureDetector(
        onTap: () {
          showImageViewer(
            context,
            img!.image,
            backgroundColor: imageViewerBackgroundColor,
          );
        },
        child: img,
      ),
      if (size != null) Text('size ${size.width}x${size.height}'),
    ];
  }

  List<Widget> _getSoundDetails(String selectedFilePath) {
    return [
      const SizedBox(height: 8),
      const Divider(),
      AudioFileDetails(filePath: selectedFilePath),
    ];
  }

  List<String> _getInheritedKeywords(
      String relativeFolderPath, DirectoryNode rootNode) {
    final folderPath = relativeFolderPath.split(pathSeparator);
    folderPath.removeWhere((e) => e.isEmpty);
    final directoryNode = rootNode.getDirectoryNode(folderPath);
    if (directoryNode == null) {
      return [];
    }
    final assetDirectories = ref.read(assetDirectoriesProvider);
    final inheritedKeywords =
        directoryNode.getInheritedKeywords(assetDirectories);
    return inheritedKeywords.toList();
  }
}
