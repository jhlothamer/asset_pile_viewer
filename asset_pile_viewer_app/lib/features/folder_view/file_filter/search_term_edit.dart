import 'package:assetPileViewer/common/util/debounce.dart';
import 'package:flutter/material.dart';

class SearchTermEdit extends StatefulWidget {
  final void Function(String) onchange;
  const SearchTermEdit({super.key, required this.onchange});

  @override
  State<SearchTermEdit> createState() => _SearchTermEditState();
}

class _SearchTermEditState extends State<SearchTermEdit> {
  final _debounce = Debounce();
  final _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchTextController,
      decoration: InputDecoration(
        labelText: 'Search ...',
        contentPadding: const EdgeInsets.all(0),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(
          Icons.search,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefix: IconButton(
          onPressed: () {
            _debounce.close();
            _searchTextController.clear();
            widget.onchange('');
          },
          icon: const Icon(Icons.close),
        ),
      ),
      onChanged: (newSearchTerm) {
        _debounce.run(() {
          widget.onchange(newSearchTerm);
        });
      },
    );
  }
}
