import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_view_filter_provider.g.dart';

class FileFilter {
  final String search;
  final List<String> keywordFilter;

  FileFilter({required this.search, required this.keywordFilter});
  factory FileFilter.empty() {
    return FileFilter(search: '', keywordFilter: []);
  }

  FileFilter copyWith({
    String? search,
    List<String>? keywordFilter,
  }) {
    return FileFilter(
      search: search ?? this.search,
      keywordFilter: keywordFilter ?? this.keywordFilter,
    );
  }
}

@riverpod
class FileViewFilter extends _$FileViewFilter {
  @override
  FileFilter build() {
    return FileFilter.empty();
  }

  void update({String? search, List<String>? keywordFilter}) {
    state = state.copyWith(search: search, keywordFilter: keywordFilter);
  }
}
