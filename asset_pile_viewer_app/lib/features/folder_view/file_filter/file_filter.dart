import 'package:assetPileViewer/common/util/debounce.dart';
import 'package:assetPileViewer/features/folder_view/file_filter/search_keyword_edit.dart';
import 'package:assetPileViewer/features/folder_view/file_filter/search_term_edit.dart';
import 'package:assetPileViewer/features/folder_view/providers/file_view_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileFilter extends ConsumerStatefulWidget {
  const FileFilter({super.key});

  @override
  ConsumerState<FileFilter> createState() => _FileFilterState();
}

class _FileFilterState extends ConsumerState<FileFilter> {
  final debounce = Debounce();
  final searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(
            height: 6.0,
          ),
          SearchTermEdit(
            onchange: (newSearchTerm) {
              ref
                  .read(fileViewFilterProvider.notifier)
                  .update(search: newSearchTerm);
            },
          ),
          const SizedBox(
            height: 6.0,
          ),
          SearchKeywordEdit(
            onChange: (keywords) {
              ref
                  .read(fileViewFilterProvider.notifier)
                  .update(keywordFilter: keywords);
            },
          ),
        ],
      ),
    );
  }
}
