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
        ProcessResult? results;
        if(Platform.isLinux || Platform.operatingSystem == 'linux') {
          results = await _launchLinux();
        } else if(Platform.isWindows){
          results = await _launchWindows();
        } else {
          debugPrint(
              'Launching explorer for OS "${Platform.operatingSystem}" is not currently supported.');
        }
        if(results == null){
          return;
        }

        if (results.exitCode != 0 && (results.stderr.toString().isNotEmpty || results.stdout.toString().isNotEmpty)) {
          debugPrint('Error launching explorer program : exit code ${results.exitCode}');
          if(results.stdout.toString().isNotEmpty)
          {
            debugPrint('stdout: ${results.stdout}');
          }
          if(results.stdout.toString().isNotEmpty)
          {
            debugPrint('stderr: ${results.stderr}');
          }
        }      
      },
      icon: const Icon(Icons.open_in_new),
    );
  }

  Future<ProcessResult> _launchLinux() async {
        const fileExplorer = 'nautilus';
        final isDirectory = await FileSystemEntity.isDirectory(path);
        final workingDir =
            isDirectory ? path : path.justPath();

        return await Process.run(
            fileExplorer,
            [
              path,
            ],
            workingDirectory: workingDir);
  }

  Future<ProcessResult> _launchWindows() async {
        const fileExplorer = 'explorer';
        final isDirectory = await FileSystemEntity.isDirectory(path);
        final workingDir =
            isDirectory ? path : path.justPath();

        //windows won't reliably open explorer and select file - so just open to the folder
        return await Process.run(
            fileExplorer,
            [
              workingDir,
            ],
            workingDirectory: workingDir);
  }
}
