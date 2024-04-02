import 'package:assetPileViewer/common/widgets/keyword_edit.dart';
import 'package:flutter/material.dart';

class KeywordEditDlg extends StatefulWidget {
  final List<String> keywords;
  final String title;
  const KeywordEditDlg(
      {super.key, required this.title, required this.keywords});

  static Future<List<String>?> show(
      BuildContext context, String title, List<String> keywords) async {
    final results = await showDialog<List<String>>(
        context: context,
        builder: (context) =>
            KeywordEditDlg(title: title, keywords: keywords.toList()));

    //check if there is a difference
    if (results != null && results.length == keywords.length) {
      if (!keywords.any((k) => !results.contains(k))) {
        return null;
      }
    }

    return results;
  }

  @override
  State<KeywordEditDlg> createState() => _KeywordEditDlgState();
}

class _KeywordEditDlgState extends State<KeywordEditDlg> {
  late KeywordEditorController _controller;
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    _controller = KeywordEditorController(widget.keywords);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 400,
        child: KeywordEdit(
          controller: _controller,
          grabFocus: true,
          textEditingController: _textEditingController,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            //submit any pending text - only close now if no new keywords added
            final pendingText = _textEditingController.text;
            if (pendingText.isNotEmpty) {
              _textEditingController.clear();
              if (_controller.add(pendingText).isNotEmpty) {
                return;
              }
            }
            Navigator.of(context).pop(_controller.keywords);
          },
          child: const Text('OK'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
