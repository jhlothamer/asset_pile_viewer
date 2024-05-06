import 'package:assetPileViewer/features/folder_view/providers/asset_lists_provider.dart';
import 'package:assetPileViewer/models/models.dart';
import 'package:assetPileViewer/repository/asset_pile_viewer_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_files_provider.g.dart';

@riverpod
class AssetFiles extends _$AssetFiles {
  @override
  Map<String, AssetFile> build() {
    final assetPileViewerRepo = ref.watch(assetPileViewerRepoProvider);

    final files = assetPileViewerRepo.getAssetFiles();

    final map = <String, AssetFile>{};
    for (final file in files) {
      map[file.path] = file;
    }

    return map;
  }

  void updateHidden(String path, bool hidden) {
    var assetFile = state[path]?.copyWith(hidden: hidden) ??
        AssetFile.newFile(path, hidden);
    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    assetFile = assetPileViewerRepo.saveFile(assetFile);

    final newState = state
        .map((key, value) => MapEntry(key, key == path ? assetFile : value));

    if (!newState.containsKey(path)) {
      newState[path] = assetFile;
    }
    state = newState;
  }

  void updateKeywords(String path, List<Keyword> keywords) {
    var assetFile = state[path]?.copyWith(keywords: keywords) ??
        AssetFile.newFile(path, false, keywords);

    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    assetFile = assetPileViewerRepo.saveFile(assetFile);

    final newState = state
        .map((key, value) => MapEntry(key, key == path ? assetFile : value));

    if (!newState.containsKey(path)) {
      newState[path] = assetFile;
    }
    state = newState;
  }

  void updateLists(String path, List<AssetList> lists) {
    var assetFile = state[path]?.copyWith(lists: lists) ??
        AssetFile.newFile(path, false, null, lists);

    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    assetFile = assetPileViewerRepo.saveFile(assetFile);

    final newState = state
        .map((key, value) => MapEntry(key, key == path ? assetFile : value));

    if (!newState.containsKey(path)) {
      newState[path] = assetFile;
    }
    state = newState;
    ref.invalidate(assetListsProvider);
  }
}
