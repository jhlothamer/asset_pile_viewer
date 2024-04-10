import 'package:assetPileViewer/common/util/debounce.dart';
import 'package:assetPileViewer/features/folder_view/file_filter/search_keyword_edit.dart';
import 'package:assetPileViewer/features/folder_view/file_filter/search_term_edit.dart';
import 'package:assetPileViewer/features/folder_view/providers/file_view_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileFilter extends ConsumerStatefulWidget {
  final Axis direction;
  const FileFilter({super.key, this.direction = Axis.horizontal});

  @override
  ConsumerState<FileFilter> createState() => _FileFilterState();
}

class _FileFilterState extends ConsumerState<FileFilter> {
  final debounce = Debounce();
  final searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final children = [
      Flexible(
        child: SearchTermEdit(
          onchange: (newSearchTerm) {
            ref
                .read(fileViewFilterProvider.notifier)
                .update(search: newSearchTerm);
          },
        ),
      ),
      const SizedBox(
        height: 6.0,
        width: 6.0,
      ),
      Flexible(
        child: SearchKeywordEdit(
          onChange: (keywords) {
            ref
                .read(fileViewFilterProvider.notifier)
                .update(keywordFilter: keywords);
          },
        ),
      ),
    ];

    final child = widget.direction == Axis.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: child,
    );
  }
}
