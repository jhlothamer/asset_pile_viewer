import 'package:assetPileViewer/features/folder_view/folder_view/directory_node.dart';
import 'package:assetPileViewer/features/folder_view/providers/file_list_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/file_view_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_file_list_provider.g.dart';

@riverpod
List<FileInfo> filteredFileList(FilteredFileListRef ref) {
  final filter = ref.watch(fileViewFilterProvider);
  final fileListInfo = ref.watch(fileListProvider);
  final search = filter.search.toLowerCase();
  final keywords = filter.keywordFilter;

  final filtered = <FileInfo>[];

  for (final fileInfo in fileListInfo.files) {
    if (!fileInfo.name.toLowerCase().contains(search)) {
      continue;
    }
    if (keywords.isNotEmpty) {
      final fileKeywords = fileListInfo.fileKeywords[fileInfo.path]!;
      if (!fileKeywords.containsAll(filter.keywordFilter)) {
        continue;
      }
    }
    filtered.add(fileInfo);
  }

  return filtered;
}
