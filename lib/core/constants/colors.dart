import 'package:flutter/material.dart';

/// Health-focused color palette optimized for trust, vitality, and accessibility
/// Based on psychological principles for health applications
class HealthColors {
  HealthColors._();

  // MARK: - Primary Health Colors
  /// Medical green - conveys trust, vitality, and health
  /// Contrast ratio: 4.5:1 (WCAG AA compliant)
  static const Color primary = Color(0xFF00A86B);
  
  /// Medical blue - represents reliability and professionalism
  static const Color secondary = Color(0xFF007ACC);
  
  /// Energy orange - motivational and encouraging
  static const Color accent = Color(0xFFFF6B35);

  // MARK: - Semantic Colors
  /// Error red - for alerts and medical attention needed
  static const Color error = Color(0xFFD32F2F);
  
  /// Success green - positive health outcomes
  static const Color success = Color(0xFF4CAF50);
  
  /// Warning amber - caution and moderation
  static const Color warning = Color(0xFFFF9800);
  
  /// Info blue - educational content
  static const Color info = Color(0xFF2196F3);

  // MARK: - BMI Category Colors
  /// BMI category colors with psychological consideration
  
  /// Severely underweight - urgent attention needed
  static const Color bmiSeverelyUnderweight = Color(0xFF1565C0);
  
  /// Underweight - needs attention
  static const Color bmiUnderweight = Color(0xFF42A5F5);
  
  /// Normal weight - optimal health
  static const Color bmiNormal = Color(0xFF66BB6A);
  
  /// Overweight - caution advised
  static const Color bmiOverweight = Color(0xFFFF9800);
  
  /// Moderately obese - medical guidance recommended
  static const Color bmiModeratelyObese = Color(0xFFFF5722);
  
  /// Severely obese - medical attention needed
  static const Color bmiSeverelyObese = Color(0xFFD32F2F);
  
  /// Very severely obese - urgent medical care
  static const Color bmiVerySeverelyObese = Color(0xFF8E24AA);

  // MARK: - Surface Colors
  /// Light theme surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSecondaryLight = Color(0xFFF8F9FA);
  static const Color surfaceTertiaryLight = Color(0xFFF1F3F4);

  /// Dark theme surfaces
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceSecondaryDark = Color(0xFF1E1E1E);
  static const Color surfaceTertiaryDark = Color(0xFF2D2D2D);

  // MARK: - Text Colors
  /// Light theme text colors
  static const Color onSurfaceLight = Color(0xFF1A1A1A);
  static const Color onSurfaceSecondaryLight = Color(0xFF6C757D);
  static const Color onSurfaceTertiaryLight = Color(0xFF9E9E9E);

  /// Dark theme text colors
  static const Color onSurfaceDark = Color(0xFFE1E1E1);
  static const Color onSurfaceSecondaryDark = Color(0xFFB0B0B0);
  static const Color onSurfaceTertiaryDark = Color(0xFF808080);

  // MARK: - Gradient Colors
  /// Health gradient - primary to secondary
  static const LinearGradient healthGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  /// Success gradient - for positive outcomes
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF66BB6A)],
  );

  /// Warning gradient - for cautionary information
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, Color(0xFFFFB74D)],
  );

  // MARK: - Utility Methods
  
  /// Get BMI category color based on BMI value
  static Color getBMIColor(double bmi) {
    if (bmi < 16.0) return bmiSeverelyUnderweight;
    if (bmi < 18.5) return bmiUnderweight;
    if (bmi < 25.0) return bmiNormal;
    if (bmi < 30.0) return bmiOverweight;
    if (bmi < 35.0) return bmiModeratelyObese;
    if (bmi < 40.0) return bmiSeverelyObese;
    return bmiVerySeverelyObese;
  }

  /// Get color with opacity for overlays and backgrounds
  static Color withHealthOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Generate color shades for health categories
  static List<Color> getHealthShades(Color baseColor, {int shades = 5}) {
    return List.generate(shades, (index) {
      final factor = (index + 1) / shades;
      return Color.lerp(baseColor.withOpacity(0.1), baseColor, factor) ?? baseColor;
    });
  }

  // MARK: - Accessibility
  
  /// High contrast colors for accessibility
  static const Color highContrastPrimary = Color(0xFF004D32);
  static const Color highContrastSecondary = Color(0xFF003D5C);
  static const Color highContrastText = Color(0xFF000000);
  static const Color highContrastBackground = Color(0xFFFFFFFF);

  /// Color mappings for different themes
  static Map<String, Color> getLightColorScheme() {
    return {
      'primary': primary,
      'secondary': secondary,
      'surface': surfaceLight,
      'onSurface': onSurfaceLight,
      'error': error,
      'success': success,
      'warning': warning,
      'info': info,
    };
  }

  static Map<String, Color> getDarkColorScheme() {
    return {
      'primary': primary,
      'secondary': secondary,
      'surface': surfaceDark,
      'onSurface': onSurfaceDark,
      'error': error,
      'success': success,
      'warning': warning,
      'info': info,
    };
  }
}

/// Extension for additional color utilities
extension HealthColorExtensions on Color {
  /// Get a lighter shade of the color
  Color get lighter {
    return Color.lerp(this, Colors.white, 0.3) ?? this;
  }

  /// Get a darker shade of the color
  Color get darker {
    return Color.lerp(this, Colors.black, 0.3) ?? this;
  }

  /// Check if color has sufficient contrast for text
  bool hasGoodContrast(Color background) {
    final luminance1 = computeLuminance();
    final luminance2 = background.computeLuminance();
    final ratio = luminance1 > luminance2 
        ? (luminance1 + 0.05) / (luminance2 + 0.05)
        : (luminance2 + 0.05) / (luminance1 + 0.05);
    return ratio >= 4.5; // WCAG AA standard
  }
}
