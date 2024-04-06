import 'package:assetPileViewer/features/folder_view/providers/asset_directories_provider.dart';
import 'package:assetPileViewer/models/models.dart' as model;
import 'package:assetPileViewer/repository/asset_pile_viewer_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_directory_provider.g.dart';

@riverpod
class AssetDirectory extends _$AssetDirectory {
  @override
  model.AssetDirectory build(String path) {
    final assetDirectories = ref.read(assetDirectoriesProvider);
    return assetDirectories[path] ?? model.AssetDirectory.newDirectory(path);
  }

  void updateHidden(bool hidden) {
    var assetDirectory = state.copyWith(hidden: hidden);
    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    assetDirectory = assetPileViewerRepo.saveDirectory(assetDirectory);
    state = assetDirectory;
  }

  void updateKeywords(List<model.Keyword> keywords) {
    ref
        .read(assetDirectoriesProvider.notifier)
        .updateKeywords(state.path, keywords);
    ref.invalidateSelf();
  }
}
