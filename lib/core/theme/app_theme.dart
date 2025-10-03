import 'package:flutter/material.dart';

/// Enum for switching between light and dark modes.
enum AppThemeMode { light, dark }

/// Centralized Theme System (Material 3, minimal, scalable).
class AppTheme {
  const AppTheme._();

  static const _seedColor = Color(0xFF6750A4);
  static const _fontFamily = 'Roboto';

  static ThemeData getThemeData(AppThemeMode mode) {
    final isDark = mode == AppThemeMode.dark;

    final base = ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorSchemeSeed: _seedColor,
      useMaterial3: true,
      fontFamily: _fontFamily,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Keep typography minimal; let M3 handle most colors.
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 14),
      ),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: base.colorScheme.surface,
        foregroundColor: base.colorScheme.onSurface,
        titleTextStyle: base.textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: base.colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: base.colorScheme.onSurfaceVariant),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: base.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      // Old ButtonTheme is legacy—keep minimal; M3 Buttons look great by default.
    );
  }
}
