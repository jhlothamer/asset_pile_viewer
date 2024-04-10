import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:assetPileViewer/features/folder_view/providers/filtered_file_list_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/playlist_toggle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_playlist_provider.g.dart';

@riverpod
List<String> audioPlayList(AudioPlayListRef ref) {
  final createPlayList = ref.watch(playListToggleProvider);
  if (!createPlayList) {
    return [];
  }
  final files = ref.watch(filteredFileListProvider);
  return files
      .where((f) => f.fileType == FileType.sound)
      .map((e) => e.path)
      .toList();
}
