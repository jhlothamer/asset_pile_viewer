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
  @override
  void dispose() {
    _debounce.close();
    super.dispose();
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

    final theme = Theme.of(context);
    final backgroundColor = theme.primaryColor;
    final selectedOptionColor = theme.secondaryHeaderColor;

    return MultiSelectDropDown<String>(
      hint: 'Keyword Filter',
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
      selectionType: SelectionType.multi,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      fieldBackgroundColor: Colors.transparent,
      optionsBackgroundColor: Colors.transparent,
      dropdownBackgroundColor: backgroundColor,
      selectedOptionBackgroundColor: selectedOptionColor,
    );
  }
}
