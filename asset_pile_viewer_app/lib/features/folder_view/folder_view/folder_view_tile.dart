import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:assetPileViewer/common/widgets/keyword_edit_dlg.dart';
import 'package:assetPileViewer/common/widgets/selected_widget_controller.dart';
import 'package:assetPileViewer/features/folder_view/folder_view/directory_node.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_directory_provider.dart'
    as provider;
import 'package:assetPileViewer/features/folder_view/providers/keywords_provider.dart';
import 'package:assetPileViewer/models/asset_directory.dart';
import 'package:assetPileViewer/models/keyword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FolderViewTile extends ConsumerStatefulWidget {
  const FolderViewTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.hidden,
    this.controller,
    this.onSelected,
    this.onHiddenChanged,
  });

  final TreeEntry<DirectoryNode> entry;
  final VoidCallback onTap;
  final bool hidden;
  final SelectedWidgetController? controller;
  final void Function()? onSelected;
  final void Function(bool)? onHiddenChanged;

  @override
  ConsumerState<FolderViewTile> createState() => _FolderViewTileState();
}

class _FolderViewTileState extends ConsumerState<FolderViewTile> {
  bool selected = false;
  bool hovered = false;
  @override
  void initState() {
    widget.controller?.addListener(_onTileControllerChanged);
    selected = widget.controller?.has(widget) ?? selected;

    if (selected && widget.onSelected != null) {
      Future.delayed(const Duration(), () {
        widget.onSelected!();
      });
    }

    super.initState();
  }

  void _onTileControllerChanged() {
    final isNowSelected = widget.controller!.has(widget);
    if (isNowSelected == selected) {
      return;
    }
    setState(() {
      selected = isNowSelected;
    });

    if (isNowSelected && widget.onSelected != null) {
      widget.onSelected!();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTileControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.entry.node.diskPath;
    final assetDirectory = ref.watch(provider.assetDirectoryProvider(path));

    final keywords = assetDirectory.keywords.map((k) => k.name).toList();
    keywords.sort();
    final keywordText = keywords.join(', ');

    return InkWell(
      onTap: () {
        widget.controller?.change(widget, true);
      },
      onDoubleTap: widget.onTap,
      onHover: (value) {
        setState(() {
          hovered = value;
        });
      },
      child: TreeIndentation(
        entry: widget.entry,
        guide: const IndentGuide.connectingLines(indent: 48),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          child: Container(
            color: selected ? Theme.of(context).focusColor : null,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                FolderButton(
                  isOpen: widget.entry.isExpanded,
                  onPressed: widget.onTap,
                  color: widget.hidden ? Theme.of(context).disabledColor : null,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entry.node.name,
                        style: widget.hidden
                            ? TextStyle(color: Theme.of(context).disabledColor)
                            : null,
                      ),
                      if (keywordText.isNotEmpty)
                        Tooltip(
                          message:
                              keywords.length == 1 ? 'Keyword' : 'Keywords',
                          child: Text(
                            keywordText,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
                if (hovered)
                  IconButton(
                    onPressed: () async {
                      await _handleKeywordEdit(context, assetDirectory);
                    },
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit Keywords',
                  ),
                if (hovered)
                  IconButton(
                    onPressed: () {
                      if (widget.onHiddenChanged != null) {
                        widget.onHiddenChanged!(!widget.hidden);
                      }
                    },
                    icon: Icon(widget.hidden
                        ? Icons.visibility
                        : Icons.visibility_off),
                    tooltip: widget.hidden ? 'Unhide' : 'Hide',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleKeywordEdit(
      BuildContext context, AssetDirectory assetDirectory) async {
    final directoryName = assetDirectory.path.fileName();
    final keywords = assetDirectory.keywords.map((e) => e.name).toList();
    final results = await KeywordEditDlg.show(
        context, 'Edit keywords for "$directoryName"', keywords);
    if (results == null) {
      return;
    }

    final savedKeywords = ref
        .read(keywordsProvider.notifier)
        .saveAll(results.map((e) => Keyword.newKeyword(name: e)).toList());
    final updatedKeywords = [...savedKeywords];
    ref
        .read(provider
            .assetDirectoryProvider(widget.entry.node.diskPath)
            .notifier)
        .updateKeywords(updatedKeywords);
  }
}
