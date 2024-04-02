import 'package:assetPileViewer/models/models.dart';
import 'package:assetPileViewer/repository/asset_pile_viewer_repo_provider.dart';
import 'package:assetPileViewer/repository/asset_pile_viewer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keywords_provider.g.dart';

@riverpod
class Keywords extends _$Keywords {
  @override
  Map<String, Keyword> build() {
    final assetPileViewerRepo = ref.watch(assetPileViewerRepoProvider);

    final keywords = assetPileViewerRepo.getKeywords();

    final map = <String, Keyword>{};
    for (final directory in keywords) {
      map[directory.name] = directory;
    }

    return map;
  }

  Keyword _save(
      AssetPileViewerRepository assetPileViewerRepo, Keyword keyword) {
    final existingKeyword = state[keyword.name];
    if (existingKeyword != null) {
      existingKeyword;
    }
    final result = assetPileViewerRepo.saveKeyword(keyword);
    return result;
  }

  Keyword save(Keyword keyword) {
    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    final result = _save(assetPileViewerRepo, keyword);
    ref.invalidateSelf();
    return result;
  }

  List<Keyword> saveAll(List<Keyword> keywords) {
    final updatedKeywords = <Keyword>[];
    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    for (final keyword in keywords) {
      updatedKeywords.add(_save(assetPileViewerRepo, keyword));
    }
    ref.invalidateSelf();
    return updatedKeywords;
  }
}
