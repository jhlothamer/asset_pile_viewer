import 'package:assetPileViewer/common/providers/theme_provider.dart';
import 'package:assetPileViewer/features/about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.settings),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            ref.read(themeProvider.notifier).toggleTheme();
          },
          leadingIcon: Icon(currentTheme == AppTheme.dark
              ? Icons.light_mode
              : Icons.dark_mode),
          child: const Text('Toggle Theme'),
        ),
        MenuItemButton(
          onPressed: () {
            showAbout(context);
          },
          leadingIcon: const Icon(Icons.info),
          child: const Text('About'),
        ),
      ],
    );
  }
}
