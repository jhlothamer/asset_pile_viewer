import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_root_folder_provider.g.dart';

const _keyAssetRootFolder = 'root_asset_folder';

@riverpod
class AssetRootFolder extends _$AssetRootFolder {
  @override
  String build() {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    final assetRootFolder =
        sharedPreferences.getString(_keyAssetRootFolder) ?? '';
    return assetRootFolder;
  }

  void update(String newAssetRootFolder) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    sharedPreferences.setString(_keyAssetRootFolder, newAssetRootFolder);
    ref.invalidateSelf();
  }
}
