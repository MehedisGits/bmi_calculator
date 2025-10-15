import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'color_schemes.dart';
import 'text_themes.dart';
import 'component_themes.dart';

/// Enum for switching between light and dark modes.
enum AppThemeMode { light, dark }

/// Health-focused Material 3 Theme System
/// Main theme composition layer that orchestrates all theme modules
class AppTheme {
  const AppTheme._();

  // Health-focused seed color for trust and vitality
  static const _healthPrimary = HealthColors.primary;
  static const _fontPrimary = 'Inter';

  /// Generate complete theme data optimized for health applications
  static ThemeData getThemeData(AppThemeMode mode) {
    final isDark = mode == AppThemeMode.dark;
    
    // Create base theme with health-focused colors
    final base = ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorSchemeSeed: _healthPrimary,
      useMaterial3: true,
      fontFamily: _fontPrimary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return base.copyWith(
      // Use modular theme builders
      colorScheme: HealthColorSchemes.buildHealthColorScheme(base.colorScheme, isDark),
      textTheme: HealthTextThemes.buildHealthTextTheme(base.textTheme, isDark),
      appBarTheme: HealthComponentThemes.buildAppBarTheme(base, isDark),
      inputDecorationTheme: HealthComponentThemes.buildInputTheme(base, isDark),
      cardTheme: HealthComponentThemes.buildCardTheme(base, isDark),
      elevatedButtonTheme: HealthComponentThemes.buildElevatedButtonTheme(base, isDark),
      filledButtonTheme: HealthComponentThemes.buildFilledButtonTheme(base, isDark),
      outlinedButtonTheme: HealthComponentThemes.buildOutlinedButtonTheme(base, isDark),
      textButtonTheme: HealthComponentThemes.buildTextButtonTheme(base, isDark),
      chipTheme: HealthComponentThemes.buildChipTheme(base, isDark),
      sliderTheme: HealthComponentThemes.buildSliderTheme(base, isDark),
      progressIndicatorTheme: HealthComponentThemes.buildProgressTheme(base, isDark),
      bottomSheetTheme: HealthComponentThemes.buildBottomSheetTheme(base, isDark),
      snackBarTheme: HealthComponentThemes.buildSnackBarTheme(base, isDark),
    );
  }

  /// Get light theme
  static ThemeData get light => getThemeData(AppThemeMode.light);
  
  /// Get dark theme
  static ThemeData get dark => getThemeData(AppThemeMode.dark);
}
