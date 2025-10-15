import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/size.dart';

/// Text theme builders for health applications
/// Provides typography optimized for health data readability
class HealthTextThemes {
  HealthTextThemes._();

  static const String _fontPrimary = 'Inter';
  static const String _fontDisplay = 'Poppins';

  /// Build typography optimized for health data
  static TextTheme buildHealthTextTheme(TextTheme base, bool isDark) {
    final primaryColor = isDark ? HealthColors.onSurfaceDark : HealthColors.onSurfaceLight;
    final secondaryColor = isDark 
        ? HealthColors.onSurfaceDark.withOpacity(0.7) 
        : HealthColors.onSurfaceLight.withOpacity(0.7);

    return base.copyWith(
      // Display styles for BMI scores
      displayLarge: _buildTextStyle(
        fontFamily: _fontDisplay,
        fontSize: AppSizes.textHero,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        height: 1.2,
      ),
      displayMedium: _buildTextStyle(
        fontFamily: _fontDisplay,
        fontSize: AppSizes.textDisplay,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        height: 1.2,
      ),
      
      // Headline styles for section headers
      headlineLarge: _buildTextStyle(
        fontFamily: _fontDisplay,
        fontSize: AppSizes.textHeading,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.3,
      ),
      headlineMedium: _buildTextStyle(
        fontFamily: _fontDisplay,
        fontSize: AppSizes.textSubheading,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.3,
      ),
      
      // Title styles for cards and components
      titleLarge: _buildTextStyle(
        fontFamily: _fontPrimary,
        fontSize: AppSizes.textTitle,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.4,
      ),
      titleMedium: _buildTextStyle(
        fontFamily: _fontPrimary,
        fontSize: AppSizes.textSubtitle,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        height: 1.4,
      ),
      
      // Body styles for content
      bodyLarge: _buildTextStyle(
        fontFamily: _fontPrimary,
        fontSize: AppSizes.textBody,
        fontWeight: FontWeight.normal,
        color: primaryColor,
        height: 1.5,
      ),
      bodyMedium: _buildTextStyle(
        fontFamily: _fontPrimary,
        fontSize: AppSizes.textBodyMedium,
        fontWeight: FontWeight.normal,
        color: primaryColor,
        height: 1.5,
      ),
      bodySmall: _buildTextStyle(
        fontFamily: _fontPrimary,
        fontSize: AppSizes.textCaption,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
        height: 1.4,
      ),
      
      // Label styles
      labelLarge: _buildTextStyle(
        fontFamily: _fontPrimary,
        fontSize: AppSizes.textLabel,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        height: 1.4,
      ),
      labelMedium: _buildTextStyle(
        fontFamily: _fontPrimary,
        fontSize: AppSizes.textLabelSmall,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        height: 1.4,
      ),
    );
  }

  /// Helper method to build text style with consistent properties
  static TextStyle _buildTextStyle({
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required double height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// Get light text theme
  static TextTheme get light {
    final base = Typography.englishLike2021;
    return buildHealthTextTheme(base, false);
  }

  /// Get dark text theme
  static TextTheme get dark {
    final base = Typography.englishLike2021;
    return buildHealthTextTheme(base, true);
  }
}
