import 'package:flutter/material.dart';

Future<bool> showConfirm(BuildContext context,
    {String title = 'Are you sure?',
    required String message,
    bool onlyOk = false}) async {
  final results = await showDialog<bool>(
    context: context,
    builder: (conext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (!onlyOk)
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

  return results ?? false;
}
