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

  bool updateList(AssetList list) {
    final listWithSameName =
        state.where((l) => l.name == list.name && l.id != list.id).firstOrNull;

    if (listWithSameName != null) {
      return false;
    }

    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    list = assetPileViewerRepo.saveAssetList(list);

    final newState = [...state.where((l) => l.id != list.id), list];
    newState.sort((a, b) => a.name.compareTo(b.name));
    state = newState;

    return true;
  }

  void deleteList(AssetList list) {
    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    assetPileViewerRepo.deleteAssetList(list);
    final newState = [...state.where((l) => l.id != list.id)];
    state = newState;
  }

  void moveListFiles(int sourceListId, int destinationListId) {
    if (!state.any((l) => l.id == sourceListId) ||
        !state.any((l) => l.id == destinationListId)) {
      //error?
      return;
    }
    final assetPileViewerRepo = ref.read(assetPileViewerRepoProvider);
    if (!assetPileViewerRepo.moveAssetListFiles(
        sourceListId, destinationListId)) {
      return;
    }
    final sourceList = state.where((l) => l.id == sourceListId).first;
    final destinationList = state.where((l) => l.id == destinationListId).first;
    final newFileCount = sourceList.fileCount + destinationList.fileCount;

    final newState = [
      ...state.where((l) => l.id != sourceListId && l.id != destinationListId),
      sourceList.copyWith(fileCount: 0),
      destinationList.copyWith(fileCount: newFileCount)
    ];
    newState.sort((a, b) => a.name.compareTo(b.name));
    state = newState;
  }
}
