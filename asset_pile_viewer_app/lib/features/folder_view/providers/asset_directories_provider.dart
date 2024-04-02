import 'package:assetPileViewer/models/models.dart';
import 'package:assetPileViewer/repository/asset_pile_viewer_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_directories_provider.g.dart';

@riverpod
class AssetDirectories extends _$AssetDirectories {
  @override
  Map<String, AssetDirectory> build() {
    final assetPileViewerRepo = ref.watch(assetPileViewerRepoProvider);

    final directories = assetPileViewerRepo.getDirectories();

    final map = <String, AssetDirectory>{};
    for (final directory in directories) {
      map[directory.path] = directory;
    }

    return map;
  }

  void updateHidden(String path, bool hidden) {
    var assetDirectory = state[path]?.copyWith(hidden: hidden) ??
        AssetDirectory.newDirectory(path, hidden);
    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    assetDirectory = assetPileViewerRepo.saveDirectory(assetDirectory);

    final newState = state.map(
        (key, value) => MapEntry(key, key == path ? assetDirectory : value));

    if (!newState.containsKey(path)) {
      newState[path] = assetDirectory;
    }
    state = newState;
  }

  void updateKeywords(String path, List<Keyword> keywords) {
    var assetDirectory = state[path]?.copyWith(keywords: keywords) ??
        AssetDirectory.newDirectory(path, false, keywords);

    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    assetDirectory = assetPileViewerRepo.saveDirectory(assetDirectory);

    final newState = state.map(
        (key, value) => MapEntry(key, key == path ? assetDirectory : value));

    if (!newState.containsKey(path)) {
      newState[path] = assetDirectory;
    }
    state = newState;
  }
}
