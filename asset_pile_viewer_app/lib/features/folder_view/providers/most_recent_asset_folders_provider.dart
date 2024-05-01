import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'most_recent_asset_folders_provider.g.dart';

const _keyMostRecentAssetFolders = 'most_recent_asset_folders';

@riverpod
class MostRecentAssetFolders extends _$MostRecentAssetFolders {
  @override
  List<String> build() {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    return sharedPreferences.getStringList(_keyMostRecentAssetFolders) ?? [];
  }

  void update(String newAssetRootFolder) {
    final newState = [
      newAssetRootFolder,
      ...state.where((folder) => folder != newAssetRootFolder)
    ];

    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    sharedPreferences.setStringList(_keyMostRecentAssetFolders, newState);

    state = newState;
  }
}
