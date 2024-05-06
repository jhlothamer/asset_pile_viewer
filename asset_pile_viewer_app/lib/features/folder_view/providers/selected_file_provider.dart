import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:assetPileViewer/features/folder_view/providers/selected_folder_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_file_provider.g.dart';

const _keySelectedFile = 'selected_file';

@riverpod
class SelectedFile extends _$SelectedFile {
  @override
  String build() {
    final selectedFolder = ref.watch(selectedFolderProvider);
    if (selectedFolder.isEmpty) {
      return '';
    }
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    final selectedFile = sharedPreferences.getString(_keySelectedFile) ?? '';

    return selectedFile;
  }

  void update(String newSelectedFile) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    sharedPreferences.setString(_keySelectedFile, newSelectedFile);
    state = newSelectedFile;
    ref.invalidateSelf();
  }

  void clear() {
    state = '';
  }
}
