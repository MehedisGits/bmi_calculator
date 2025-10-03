import 'package:bmi_calculator/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Holds current theme mode and notifies listeners on changes.
final appThemeModeProvider = StateProvider<AppThemeMode>(
  (ref) => AppThemeMode.light,
);

/// Computed provider that returns ThemeData based on current AppThemeMode.
final appThemeProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(appThemeModeProvider);
  return AppTheme.getThemeData(mode);
});
