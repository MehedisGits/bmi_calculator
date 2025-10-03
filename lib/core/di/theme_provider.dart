import 'package:bmi_calculator/core/prefs/shared_prefs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

const _themePrefKey = 'app_theme_mode';

class AppThemeController extends Notifier<AppThemeMode> {
  late final SharedPreferences _prefs;

  @override
  AppThemeMode build() {
    _prefs = ref.read(sharedPrefsProvider);
    final saved = _prefs.getString(_themePrefKey);
    if (saved == null) return AppThemeMode.light;
    return saved == 'dark' ? AppThemeMode.dark : AppThemeMode.light;
  }

  void setTheme(AppThemeMode mode) {
    state = mode;
    _prefs.setString(
      _themePrefKey,
      mode == AppThemeMode.dark ? 'dark' : 'light',
    );
  }

  void toggleTheme() {
    setTheme(
      state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light,
    );
  }
}

/// Holds current theme mode (light/dark).
final appThemeModeProvider = NotifierProvider<AppThemeController, AppThemeMode>(
  AppThemeController.new,
);

/// Computed ThemeData for MaterialApp.
final appThemeDataProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(appThemeModeProvider);
  return AppTheme.getThemeData(mode);
});
