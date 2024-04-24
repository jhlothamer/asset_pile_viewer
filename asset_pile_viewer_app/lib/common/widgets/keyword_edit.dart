import 'package:flutter/material.dart';

class KeywordEditorController extends ChangeNotifier {
  final List<String> keywords;
  final List<String>? acceptableKeywords;
  KeywordEditorController(this.keywords, [this.acceptableKeywords]);

  List<String> add(String keywordsString) {
    var changed = false;
    final newKeywords = <String>[];
    final enteredKeywords = keywordsString
        .toLowerCase()
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty);
    for (final keyword in enteredKeywords) {
      if (acceptableKeywords != null &&
          !acceptableKeywords!.contains(keyword.toLowerCase())) {
        continue;
      }

      if (!keywords.contains(keyword)) {
        keywords.add(keyword);
        newKeywords.add(keyword);
        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
    }

    return newKeywords;
  }

  void remove(String keyword) {
    if (keywords.remove(keyword)) {
      notifyListeners();
    }
  }
}

class KeywordEdit extends StatefulWidget {
  final KeywordEditorController controller;
  final void Function(String)? onKeywordDeleted;
  final void Function(List<String>)? onKeywordsAdded;
  final bool grabFocus;
  final TextEditingController? textEditingController;
  final String noun;
  const KeywordEdit({
    super.key,
    required this.controller,
    this.onKeywordDeleted,
    this.onKeywordsAdded,
    this.grabFocus = false,
    this.textEditingController,
    this.noun = 'keyword',
  });

  @override
  State<KeywordEdit> createState() => _KeywordEditState();
}

class _KeywordEditState extends State<KeywordEdit> {
  late TextEditingController _textController;
  final _focusNode = FocusNode();

  @override
  void initState() {
    _textController = widget.textEditingController ?? TextEditingController();
    if (widget.grabFocus) {
      _focusNode.requestFocus();
    }

    widget.controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    if (widget.textEditingController == null) {
      _textController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [..._keywordChips()],
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: _textController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'Add new ${widget.noun}s (comma separated)',
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (keywords) {
            final newKeywords = widget.controller.add(keywords);
            _textController.clear();
            _focusNode.requestFocus();
            setState(() {});
            if (widget.onKeywordsAdded != null) {
              widget.onKeywordsAdded!(newKeywords);
            }
          },
        ),
      ],
    );
  }

  List<Widget> _keywordChips() {
    final keywords = widget.controller.keywords;

    if (keywords.isEmpty) {
      return [
        Text(
          'No ${widget.noun}s',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).disabledColor,
          ),
        )
      ];
    }

    keywords.sort();
    final chips = <Widget>[];

    for (final keyword in keywords) {
      chips.add(
        InputChip(
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).focusColor,
          side: BorderSide.none,
          deleteButtonTooltipMessage: 'Remove ${widget.noun}',
          label: Text(keyword),
          onDeleted: () {
            widget.controller.remove(keyword);
            setState(() {});
            if (widget.onKeywordDeleted != null) {
              widget.onKeywordDeleted!(keyword);
            }
          },
        ),
      );
    }

    return chips;
  }
}
