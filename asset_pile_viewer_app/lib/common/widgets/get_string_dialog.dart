import 'package:flutter/material.dart';

Future<String?> showGetStringDialog(
  BuildContext context, {
  required String prompt,
  String? value,
  String? title,
  List<String>? disallowedValues,
  String? disallowedValueErrorText,
  Map<String, String>? extraActionValueMap,
  int maxLength = 100,
}) async {
  final results = await showDialog(
    context: context,
    builder: (context) => GetStringDialog(
      prompt: prompt,
      title: title,
      value: value,
      disallowedValueErrorText: disallowedValueErrorText,
      disallowedValues: disallowedValues,
      extraActionValueMap: extraActionValueMap,
      maxLength: maxLength,
    ),
  );

  return results;
}

class GetStringDialog extends StatefulWidget {
  final String? title;
  final String prompt;
  final String? value;
  final int maxLength;
  final List<String>? disallowedValues;
  final String? disallowedValueErrorText;
  final Map<String, String>? extraActionValueMap;

  const GetStringDialog({
    super.key,
    required this.prompt,
    this.value,
    this.title,
    this.disallowedValues,
    this.disallowedValueErrorText,
    this.extraActionValueMap,
    this.maxLength = 100,
  });

  @override
  State<GetStringDialog> createState() => _GetStringDialogState();
}

class _GetStringDialogState extends State<GetStringDialog> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title!),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            maxLength: widget.maxLength,
            autofocus: true,
            focusNode: _focusNode,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.prompt,
              errorText: _errorText,
            ),
            onSubmitted: (value) {
              _processEnteredString(_controller.text);
            },
          ),
        ],
      ),
      actions: [
        ..._extraActionButtons(),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            _processEnteredString(_controller.text);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  List<Widget> _extraActionButtons() {
    if (widget.extraActionValueMap == null ||
        widget.extraActionValueMap!.isEmpty) {
      return [];
    }
    final buttons = <Widget>[];
    for (final buttonText in widget.extraActionValueMap!.keys) {
      final returnString = widget.extraActionValueMap![buttonText]!;
      buttons.add(FilledButton(
          onPressed: () {
            Navigator.of(context).pop(returnString);
          },
          child: Text(buttonText)));
    }
    return buttons;
  }

  void _processEnteredString(String value) {
    final trimmedValue = value.trim().toLowerCase();
    if (trimmedValue.isEmpty) {
      _controller.clear();
      _focusNode.requestFocus();
      setState(() {
        _errorText = 'Cannot be blank';
      });
      return;
    }

    if (widget.disallowedValues?.any((s) => s == trimmedValue) ?? false) {
      _focusNode.requestFocus();
      setState(() {
        _errorText = widget.disallowedValueErrorText ?? 'Invalid value';
      });
      return;
    }
    Navigator.of(context).pop(trimmedValue);
  }
}
