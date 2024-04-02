import 'package:assetPileViewer/data/db_util.dart';
import 'package:assetPileViewer/repository/asset_pile_viewer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_pile_viewer_repo_provider.g.dart';

@riverpod
AssetPileViewerRepository assetPileViewerRepo(AssetPileViewerRepoRef ref) {
  return AssetPileViewerRepository(dbFilepath);
}
