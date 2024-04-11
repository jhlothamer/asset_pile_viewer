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
        if(Platform.isLinux || Platform.operatingSystem == 'linux') {
          await _launchLinux();
        } else if(Platform.isWindows){
          await _launchWindows();
        } else {
          debugPrint(
              'Launching explorer for OS "${Platform.operatingSystem}" is not currently supported.');
        }
      },
      icon: const Icon(Icons.open_in_new),
    );
  }

  Future<void> _launchLinux() async {
        const fileExplorer = 'nautilus';
        final isDirectory = await FileSystemEntity.isDirectory(path);
        final workingDir =
            isDirectory ? path : path.justPath();

        final results = await Process.run(
            fileExplorer,
            [
              path,
            ],
            workingDirectory: workingDir);
        
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
        }    }

  Future<void> _launchWindows() async {
        const fileExplorer = 'explorer';
        final isDirectory = await FileSystemEntity.isDirectory(path);
        final workingDir =
            isDirectory ? path : path.justPath();

        final proc = await Process.start("cmd", [], workingDirectory: workingDir, runInShell: true);
        proc.stdin.writeln('$fileExplorer /select,"$path"');
        debugPrint('proc id = ${proc.pid}');
        proc.stdin.writeln('exit');
  }
}
