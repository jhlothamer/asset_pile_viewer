import 'package:assetPileViewer/common/providers/theme_provider.dart';
import 'package:assetPileViewer/data/db_util.dart';
import 'package:assetPileViewer/common/routes.dart';
import 'package:assetPileViewer/common/providers/shared_prefs_provider.dart';
import 'package:assetPileViewer/data/asset_pile_viewer_db_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDbFilePath();
  final assetPileViewerDbSchema = AssetPileViewerDbSchema(dbFilepath);
  assetPileViewerDbSchema.update();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    final theme = currentTheme == AppTheme.light
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);

    return MaterialApp(
      title: 'Asset Manager',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        scrollbarTheme: const ScrollbarThemeData(
          thumbVisibility: MaterialStatePropertyAll<bool>(true),
        ),
      ),
      onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(settings, ref),
    );
  }
}
