import 'package:assetPileViewer/models/models.dart';
import 'package:assetPileViewer/repository/asset_pile_viewer_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_lists_provider.g.dart';

@riverpod
class AssetLists extends _$AssetLists {
  @override
  List<AssetList> build() {
    final assetPileViewerRepo = ref.watch(assetPileViewerRepoProvider);
    return assetPileViewerRepo.getAssetLists();
  }

  AssetList addList(String name) {
    final lowerCaseName = name.toLowerCase();
    final existingList =
        state.where((l) => l.name.toLowerCase() == lowerCaseName).firstOrNull;
    if (existingList != null) {
      return existingList;
    }

    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    final newList =
        assetPileViewerRepo.saveAssetList(AssetList.newAssetList(name: name));

    final newState = [...state, newList];
    newState.sort((a, b) => a.name.compareTo(b.name));
    state = newState;

    return newList;
  }

  AssetList updateList(AssetList list) {
    if (list.id == 0) {
      return addList(list.name);
    }

    final listWithSameName =
        state.where((l) => l.name == list.name && l.id != list.id).firstOrNull;

    if (listWithSameName != null) {
      final existingList = state.where((l) => l.id == list.id).firstOrNull;
      if (existingList == null) {
        throw 'A list with name ${list.name} exists but updated list not in state list!  id:${list.id}';
      }
      return existingList;
    }

    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    list = assetPileViewerRepo.saveAssetList(list);

    final newState = [...state.where((l) => l.id != list.id), list];
    newState.sort((a, b) => a.name.compareTo(b.name));
    state = newState;

    return list;
  }
}
