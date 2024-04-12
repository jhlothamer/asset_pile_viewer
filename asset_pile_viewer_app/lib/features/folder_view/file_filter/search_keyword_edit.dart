import 'package:assetPileViewer/common/util/debounce.dart';
import 'package:assetPileViewer/features/folder_view/providers/keywords_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class SearchKeywordEdit extends ConsumerStatefulWidget {
  final void Function(List<String>) onChange;
  const SearchKeywordEdit({super.key, required this.onChange});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchKeywordEditState();
}

class _SearchKeywordEditState extends ConsumerState<SearchKeywordEdit> {
  List<String> selectedKeywords = [];
  final _debounce = Debounce();
  final _controller = MultiSelectController<String>();
  @override
  void dispose() {
    _debounce.close();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keywords = ref.watch(keywordsProvider).keys.toList();
    keywords.sort();

    final items = keywords
        .map(
          (k) => ValueItem(
            value: k,
            label: k,
          ),
        )
        .toList();
    final selectedItems =
        items.where((i) => selectedKeywords.contains(i.value)).toList();

    _controller.setOptions(items);
    _controller.setSelectedOptions(selectedItems);

    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.background;
    final selectedOptionColor = theme.colorScheme.onBackground; //secondary

    return MultiSelectDropDown<String>(
      key: const Key('Keyword Filter'),
      hint: 'Keyword Filter',
      controller: _controller,
      onOptionSelected: (selectedOptions) {
        selectedKeywords = selectedOptions.map((e) => e.value!).toList();
        _debounce.run(() {
          widget.onChange(selectedKeywords);
        });
      },
      onOptionRemoved: (index, option) {
        selectedKeywords.remove(option.value!);
        _debounce.run(() {
          widget.onChange(selectedKeywords);
        });
      },
      options: items,
      selectedOptions: selectedItems,
      selectionType: SelectionType.multi,
      chipConfig: ChipConfig(
        wrapType: WrapType.wrap,
        backgroundColor: backgroundColor,
        labelColor: selectedOptionColor,
        deleteIconColor: selectedOptionColor,
      ),
      fieldBackgroundColor: Colors.transparent,
      optionsBackgroundColor: Colors.transparent,
      dropdownBackgroundColor: backgroundColor,
      selectedOptionBackgroundColor: selectedOptionColor,
      selectedOptionTextColor: backgroundColor,
    );
  }
}
