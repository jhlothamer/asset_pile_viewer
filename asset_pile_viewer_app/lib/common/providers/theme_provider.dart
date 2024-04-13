import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

const _sharedPrefKeyThemeMode = 'theme_mode';

enum AppTheme {
  light,
  dark,
}

@riverpod
class Theme extends _$Theme {
  @override
  AppTheme build() {
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    final index = sharedPrefs.getInt(_sharedPrefKeyThemeMode) ?? 0;
    final mode = AppTheme.values[index];
    return mode;
  }

  void toggleTheme() {
    final newMode = state == AppTheme.light ? AppTheme.dark : AppTheme.light;
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    sharedPrefs.setInt(_sharedPrefKeyThemeMode, newMode.index);
    state = newMode;
  }
}
