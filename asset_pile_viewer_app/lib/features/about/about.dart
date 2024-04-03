import 'package:assetPileViewer/common/app_version.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const _contentWidth = 400.0;
const _githubUrl = 'https://github.com/jhlothamer/asset_pile_viewer';

void _showLicenseDialog(BuildContext context) async {
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
}

void _launchSourceCodeUrl() {
  launchUrlString(_githubUrl);
}

void showAbout(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: 'Asset Pile Viewer',
    applicationVersion: appVersion.toString(),
    applicationLegalese: '\u{a9} 2024 Jason Lothamer',
    applicationIcon: Image.asset('assets/images/app_icon.png'),
    children: [
      const SizedBox(
        height: 20,
      ),
      RichText(
        text: TextSpan(children: [
          const TextSpan(text: 'This software is licensed under '),
          TextSpan(
              text: 'GNU General Public License V3',
              style: const TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _showLicenseDialog(context)),
          const TextSpan(text: '.'),
        ]),
      ),
      const SizedBox(
        height: 20,
      ),
      RichText(
        text: const TextSpan(children: [
          TextSpan(text: 'A copy of the source code can be obtained at '),
        ]),
      ),
      const SizedBox(
        height: 10,
      ),
      RichText(
        text: TextSpan(children: [
          TextSpan(
              text: _githubUrl,
              style: const TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()..onTap = _launchSourceCodeUrl),
        ]),
      ),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
        width: _contentWidth,
        child: RichText(
          text: const TextSpan(
              text:
                  'To view packages used by this software and their licenses, click the View Licenses button below.'),
        ),
      ),
    ],
  );
}
