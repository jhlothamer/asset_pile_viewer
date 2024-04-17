import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sort_order_provider.g.dart';

enum SortDirection {
  ascending,
  descending,
}

@riverpod
class SortOrder extends _$SortOrder {
  @override
  SortDirection build() {
    return SortDirection.ascending;
  }

  void toggle() {
    if (state == SortDirection.ascending) {
      state = SortDirection.descending;
    } else {
      state = SortDirection.ascending;
    }
  }
}
