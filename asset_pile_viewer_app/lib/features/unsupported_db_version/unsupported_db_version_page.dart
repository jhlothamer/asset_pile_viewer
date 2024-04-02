import 'package:assetPileViewer/common/widgets/open_file_explorer_button.dart';
import 'package:assetPileViewer/data/asset_pile_viewer_db_schema.dart';
import 'package:assetPileViewer/data/db_util.dart';
import 'package:flutter/material.dart';

class UnsupportedDbVersionPage extends StatelessWidget {
  const UnsupportedDbVersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Unsupported DB Version Found.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'DB Version found: $foundSchemaVersion',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'DB Version expected: $currentSchemaVersion',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            OpenFileExplorerButton(path: dbFilepath),
          ],
        ),
      ),
    );
  }
}
