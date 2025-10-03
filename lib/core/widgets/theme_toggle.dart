import 'package:bmi_calculator/core/di/theme_provider.dart';
import 'package:bmi_calculator/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appThemeModeProvider);
    final isDark = mode == AppThemeMode.dark;
    return IconButton(
      onPressed: () {
        ref.read(appThemeModeProvider.notifier).toggleTheme();
      },
      icon: Icon(
        isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        size: 28,
        semanticLabel: isDark
            ? 'Switch to light theme'
            : 'Switch to dark theme',
      ),
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      color: isDark ? Colors.yellow : Colors.blueGrey,
    );
  }
}
