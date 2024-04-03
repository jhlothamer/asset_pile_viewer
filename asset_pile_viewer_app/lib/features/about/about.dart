import 'package:flutter/services.dart' show rootBundle;
import 'package:assetPileViewer/data/asset_pile_viewer_db_schema.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

void showAbout(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: 'Asset Pile Viewer',
    applicationVersion: currentSchemaVersion.toString(),
    applicationLegalese: '\u{a9} 2024 Jason Lothamer',
    applicationIcon: Image.asset('assets/images/app_icon.png'),
    children: [
      Flex(
        direction: Axis.horizontal,
        children: [
          const Text('License:'),
          InkWell(
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'GPL-3.0',
                style: TextStyle(decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () async {
              var licenseText = await rootBundle.loadString('assets/LICENSE');
              if (!context.mounted) {
                return;
              }
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('License'),
                    content: SingleChildScrollView(
                      child: Text(licenseText),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      Flex(
        direction: Axis.horizontal,
        children: [
          const Text('Source Code:'),
          InkWell(
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'https://github.com/jhlothamer/asset_pile_viewer',
                style: TextStyle(decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () {
              launchUrlString(
                  'https://github.com/jhlothamer/asset_pile_viewer');
            },
          ),
        ],
      ),
    ],
  );
}
