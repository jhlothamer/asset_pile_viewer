import 'package:assetPileViewer/features/folder_view/providers/sort_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SortOrderToggleButton extends ConsumerStatefulWidget {
  const SortOrderToggleButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SortOrderToggleButtonState();
}

class _SortOrderToggleButtonState extends ConsumerState<SortOrderToggleButton> {
  @override
  Widget build(BuildContext context) {
    final sortDirection = ref.watch(sortOrderProvider);
    return IconButton(
      tooltip:
          'Toggle Sorting (currently ${sortDirection == SortDirection.ascending ? 'ascending' : 'descending'})',
      onPressed: () {
        ref.read(sortOrderProvider.notifier).toggle();
      },
      icon: Row(
        children: [
          const Icon(Icons.sort_by_alpha),
          if (sortDirection == SortDirection.ascending)
            const Icon(Icons.north)
          else
            const Icon(Icons.south)
        ],
      ),
    );
  }
}
