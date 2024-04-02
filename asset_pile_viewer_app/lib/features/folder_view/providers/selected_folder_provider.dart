import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/asset_root_folder_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_folder_provider.g.dart';

const _keySelectedFolder = 'selected_folder';

@riverpod
class SelectedFolder extends _$SelectedFolder {
  @override
  String build() {
    final assetRootFolder = ref.watch(assetRootFolderProvider);

    if (assetRootFolder.isEmpty) {
      return '';
    }

    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    final selectedFolder =
        sharedPreferences.getString(_keySelectedFolder) ?? '';

    if (!selectedFolder.startsWith(assetRootFolder)) {
      return '';
    }

    return selectedFolder;
  }

  void update(final newSelectedFolder) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    sharedPreferences.setString(_keySelectedFolder, newSelectedFolder);
    ref.invalidateSelf();
  }

  void clear() {
    update('');
  }
}
