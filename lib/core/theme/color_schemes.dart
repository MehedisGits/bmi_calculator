import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Color scheme builders for health-focused themes
/// Provides light and dark color schemes optimized for health applications
class HealthColorSchemes {
  HealthColorSchemes._();

  /// Build health-focused color scheme
  static ColorScheme buildHealthColorScheme(ColorScheme base, bool isDark) {
    return base.copyWith(
      primary: HealthColors.primary,
      secondary: HealthColors.secondary,
      tertiary: HealthColors.accent,
      error: HealthColors.error,
      surface: isDark ? HealthColors.surfaceDark : HealthColors.surfaceLight,
      onSurface: isDark ? HealthColors.onSurfaceDark : HealthColors.onSurfaceLight,
    );
  }

  /// Get light color scheme
  static ColorScheme get light {
    final base = ColorScheme.fromSeed(
      seedColor: HealthColors.primary,
      brightness: Brightness.light,
    );
    return buildHealthColorScheme(base, false);
  }

  /// Get dark color scheme
  static ColorScheme get dark {
    final base = ColorScheme.fromSeed(
      seedColor: HealthColors.primary,
      brightness: Brightness.dark,
    );
    return buildHealthColorScheme(base, true);
  }
}
