import 'dart:io';

import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_root_folder_provider.g.dart';

const keyAssetRootFolder = 'root_asset_folder';

@riverpod
class AssetRootFolder extends _$AssetRootFolder {
  @override
  String build() {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    final assetRootFolder =
        sharedPreferences.getString(keyAssetRootFolder) ?? '';
    if (assetRootFolder.isNotEmpty) {
      if (!FileSystemEntity.isDirectorySync(assetRootFolder)) {
        return '';
      }
    }
    return assetRootFolder;
  }

  void update(String newAssetRootFolder) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    sharedPreferences.setString(keyAssetRootFolder, newAssetRootFolder);
    ref.invalidateSelf();
  }
}
