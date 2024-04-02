import 'dart:collection';

import 'package:flutter/material.dart';

class SelectedWidgetController extends ChangeNotifier {
  final _selectedWidgets = HashSet<Key>();

  final bool multiSelect;
  SelectedWidgetController({this.multiSelect = false});

  void _select(Key key) {
    if (!multiSelect && _selectedWidgets.isNotEmpty) {
      _selectedWidgets.clear();
    }

    _selectedWidgets.add(key);

    notifyListeners();
  }

  void _deSelect(Key key) {
    if (_selectedWidgets.remove(key)) {
      notifyListeners();
    }
  }

  void change(Widget widget, bool selected) {
    if (widget.key == null) {
      throw 'Widgets using SelectedWidgetController must have a key set.';
    }
    changeWithKey(widget.key!, selected);
  }

  void changeWithKey(Key key, bool selected) {
    if (selected) {
      _select(key);
    } else {
      _deSelect(key);
    }
  }

  bool has(Widget widget) {
    if (widget.key == null) {
      throw 'Widgets using SelectedWidgetController must have a key set.';
    }
    return _selectedWidgets.any((key) => key == widget.key);
  }

  bool isNotEmpty() {
    return _selectedWidgets.isNotEmpty;
  }

  void clear() {
    _selectedWidgets.clear();
    notifyListeners();
  }
}
