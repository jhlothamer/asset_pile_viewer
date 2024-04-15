import 'dart:io';

import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:assetPileViewer/common/routes.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_root_folder_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_folder_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _spacing = 20.0;

class FirstRunPage extends ConsumerStatefulWidget {
  const FirstRunPage({super.key});

  @override
  ConsumerState<FirstRunPage> createState() => _FirstRunPageState();
}

class _FirstRunPageState extends ConsumerState<FirstRunPage> {
  final _textEditingController = TextEditingController();
  String? _errorText;
  @override
  Widget build(BuildContext context) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    final assetRootFolder = sharedPreferences.getString(keyAssetRootFolder);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 800,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter an asset root folder',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                height: _spacing,
              ),
              if (assetRootFolder != null) ...[
                Text(
                  'An asset root folder that was previously selected is missing.  It could have been moved, renamed or deleted.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Previously selected folder: $assetRootFolder',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: _spacing,
                ),
              ] else ...[
                Text(
                  'The Asset Pile Viewer shows all supported asset files in a folder and its children. '
                  'To get started, please enter or select a folder.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: _spacing,
                ),
              ],
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        errorText: _errorText,
                      ),
                      onChanged: (value) {
                        if (!FileSystemEntity.isDirectorySync(value)) {
                          setState(() {
                            _errorText = 'Please enter a valid folder path';
                          });
                        } else {
                          setState(() {
                            _errorText = null;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: _spacing,
                  ),
                  IconButton(
                    onPressed: () async {
                      final directoryPath =
                          (await getDirectoryPath(initialDirectory: ''))
                              ?.trim();

                      if (directoryPath == null || directoryPath.isEmpty) {
                        return;
                      }
                      _textEditingController.text = directoryPath;
                      setState(() {
                        _errorText = null;
                      });
                    },
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
              const SizedBox(
                height: _spacing,
              ),
              Text(
                'This root folder can be changed later from the drop down menu in the folder tree pane.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: _spacing,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (!FileSystemEntity.isDirectorySync(
                          _textEditingController.text)) {
                        setState(() {
                          _errorText = 'Please enter a valid folder path';
                        });
                        return;
                      }
                      ref
                          .read(assetRootFolderProvider.notifier)
                          .update(_textEditingController.text);
                      ref
                          .read(selectedFolderProvider.notifier)
                          .update(_textEditingController.text);
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.application);
                    },
                    child: const Text(
                      'Continue',
                      //style: Theme.of(context).textTheme.displayMedium,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
