import 'package:assetPileViewer/features/folder_view/providers/asset_lists_provider.dart';
import 'package:assetPileViewer/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_asset_list_provider.g.dart';

@riverpod
class SelectedAssetList extends _$SelectedAssetList {
  @override
  AssetList? build() {
    final assetListsProviderSub =
        ref.listen(assetListsProvider, (previous, next) {
      if (state == null) {
        return;
      }
      state = next.where((l) => l.id == state!.id).firstOrNull;
    });
    ref.onDispose(() {
      assetListsProviderSub.close();
    });
    return null;
  }

  void select(AssetList list) {
    final assetLists = ref.read(assetListsProvider);
    state = assetLists.where((l) => l.id == list.id).firstOrNull;
  }

  void clear() {
    state = null;
  }
}
