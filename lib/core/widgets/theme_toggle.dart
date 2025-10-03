import 'package:bmi_calculator/core/di/theme_provider.dart';
import 'package:bmi_calculator/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: IconButton(
        icon: Icon(
          ref.watch(appThemeModeProvider) == AppThemeMode.dark
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round,
        ),
        onPressed: () {
          final currentMode = ref.read(appThemeModeProvider);
          final newMode = currentMode == AppThemeMode.dark
              ? AppThemeMode.light
              : AppThemeMode.dark;
          ref.read(appThemeModeProvider.notifier).state = newMode;
        },
      ),
    );
  }
}
