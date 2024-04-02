import 'dart:io';

import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:flutter/material.dart';

class OpenFileExplorerButton extends StatelessWidget {
  final String path;
  const OpenFileExplorerButton({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Open explorer to $path',
      onPressed: () async {
        var fileExplorer = '';
        if (Platform.isWindows) {
          fileExplorer = 'explorer';
        } else if (Platform.isLinux || Platform.operatingSystem == 'linux') {
          fileExplorer = 'nautilus';
        } else {
          debugPrint(
              'Launching explorer for OS "${Platform.operatingSystem}" is not currently supported.');
          return;
        }

        final workingDir =
            FileSystemEntity.isDirectorySync(path) ? path : path.justPath();

        final results = await Process.run(
            fileExplorer,
            [
              path,
            ],
            workingDirectory: workingDir);

        if (results.exitCode != 0) {
          debugPrint('Error launching explorer program "$fileExplorer"');
          debugPrint('${results.stdout}');
          debugPrint('${results.stderr}');
        }
      },
      icon: const Icon(Icons.open_in_new),
    );
  }
}
