import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_hidden_folders_provider.g.dart';

const _keyShowHiddenFolders = 'show_hidden_folders';

@riverpod
class ShowHiddenFolders extends _$ShowHiddenFolders {
  @override
  bool build() {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    return sharedPreferences.getBool(_keyShowHiddenFolders) ?? false;
  }

  void update(bool showHidden) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    sharedPreferences.setBool(_keyShowHiddenFolders, showHidden);
    ref.invalidateSelf();
  }
}
