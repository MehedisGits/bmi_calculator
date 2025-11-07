import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import '../constants/size.dart';
import '../theme/app_theme.dart';

/// Centralized Theme Service that provides consistent access to theme properties
/// Eliminates context dependency and provides clean API for theme access
class ThemeService {
  final ThemeData _themeData;
  final bool _isDark;

  const ThemeService._(this._themeData, this._isDark);

  /// Create theme service from context
  factory ThemeService.fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ThemeService._(theme, isDark);
  }

  /// Create theme service from theme mode
  factory ThemeService.fromMode(AppThemeMode mode) {
    final themeData = AppTheme.getThemeData(mode);
    final isDark = mode == AppThemeMode.dark;
    return ThemeService._(themeData, isDark);
  }

  // MARK: - Core Theme Properties
  ThemeData get themeData => _themeData;
  ColorScheme get colorScheme => _themeData.colorScheme;
  TextTheme get textTheme => _themeData.textTheme;
  bool get isDark => _isDark;

  // MARK: - Health Colors
  Color get healthPrimary => HealthColors.primary;
  Color get healthSecondary => HealthColors.secondary;
  Color get healthAccent => HealthColors.accent;
  Color get healthSuccess => HealthColors.success;
  Color get healthWarning => HealthColors.warning;
  Color get healthError => HealthColors.error;
  Color get healthInfo => HealthColors.info;

  /// Get BMI-specific color
  Color getBMIColor(double bmi) => HealthColors.getBMIColor(bmi);

  /// Get surface colors based on theme mode
  Color get healthSurface => _isDark ? HealthColors.surfaceDark : HealthColors.surfaceLight;
  Color get healthOnSurface => _isDark ? HealthColors.onSurfaceDark : HealthColors.onSurfaceLight;

  // MARK: - Spacing
  double get spaceXS => AppSizes.spaceXS;
  double get spaceSmall => AppSizes.spaceSmall;
  double get spaceMedium => AppSizes.spaceMedium;
  double get spaceLarge => AppSizes.spaceLarge;
  double get spaceXLarge => AppSizes.spaceXLarge;
  double get spaceXXLarge => AppSizes.spaceXXLarge;

  // MARK: - Padding
  double get paddingXS => AppSizes.paddingXS;
  double get paddingSmall => AppSizes.paddingSmall;
  double get paddingMedium => AppSizes.paddingMedium;
  double get paddingLarge => AppSizes.paddingLarge;
  double get paddingXLarge => AppSizes.paddingXLarge;

  // MARK: - Border Radius
  BorderRadius get radiusSmall => AppRadius.small;
  BorderRadius get radiusMedium => AppRadius.medium;
  BorderRadius get radiusLarge => AppRadius.large;
  BorderRadius get radiusXLarge => AppRadius.xLarge;
  BorderRadius get buttonRadius => AppRadius.button;
  BorderRadius get cardRadius => AppRadius.card;
  BorderRadius get inputRadius => AppRadius.input;
  
  // Additional border radius getters for consistency
  BorderRadius get borderRadiusXXS => BorderRadius.circular(AppSizes.radiusXXS);
  BorderRadius get borderRadiusXSmall => BorderRadius.circular(AppSizes.radiusXSmall);
  BorderRadius get borderRadiusSmall => BorderRadius.circular(AppSizes.radiusSmall);
  BorderRadius get borderRadiusMedium => BorderRadius.circular(AppSizes.radiusMedium);
  BorderRadius get borderRadiusLarge => BorderRadius.circular(AppSizes.radiusLarge);
  BorderRadius get borderRadiusXLarge => BorderRadius.circular(AppSizes.radiusXLarge);
  BorderRadius get borderRadiusXXLarge => BorderRadius.circular(AppSizes.radiusXXLarge);

  // MARK: - Border Width
  double get borderWidthThin => AppSizes.borderWidthThin;
  double get borderWidthNormal => AppSizes.borderWidthNormal;
  double get borderWidthThick => AppSizes.borderWidthThick;
  double get borderWidthThickest => AppSizes.borderWidthThickest;

  // MARK: - Component Sizes
  double get buttonHeightXSmall => AppSizes.buttonHeightXSmall;
  double get buttonHeight => AppSizes.buttonHeight;
  double get buttonHeightSmall => AppSizes.buttonHeightSmall;
  double get buttonHeightLarge => AppSizes.buttonHeightLarge;
  double get buttonHeightXLarge => AppSizes.buttonHeightXLarge;
  double get inputHeight => AppSizes.inputHeight;
  double get bmiScoreSize => AppSizes.bmiScoreSize;
  double get healthTipCardHeight => AppSizes.healthTipCardHeight;
  double get sliderHeight => AppSizes.sliderHeight;
  
  // MARK: - Icon Sizes
  double get iconSizeSmall => AppSizes.iconSmall;
  double get iconSizeMedium => AppSizes.iconMedium;
  double get iconSizeLarge => AppSizes.iconLarge;
  
  // MARK: - Shadow Styles
  BoxShadow get shadowCard => BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 8,
    offset: const Offset(0, 2),
    spreadRadius: 0,
  );
  
  BoxShadow get shadowButton => BoxShadow(
    color: healthPrimary.withOpacity(0.2),
    blurRadius: 12,
    offset: const Offset(0, 4),
    spreadRadius: 0,
  );
  
  BoxShadow get shadowError => BoxShadow(
    color: healthError.withOpacity(0.2),
    blurRadius: 8,
    offset: const Offset(0, 2),
    spreadRadius: 0,
  );

  // MARK: - Typography Helpers
  TextStyle? get heroText => textTheme.displayLarge;
  TextStyle? get headingText => textTheme.headlineLarge;
  TextStyle? get titleText => textTheme.titleLarge;
  TextStyle? get bodyText => textTheme.bodyLarge;
  TextStyle? get captionText => textTheme.bodySmall;

  TextStyle? get bmiScoreStyle => textTheme.displayLarge?.copyWith(
    color: healthPrimary,
    fontWeight: FontWeight.bold,
  );

  TextStyle? get healthCategoryStyle => textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.w600,
  );

  TextStyle? get healthTipStyle => textTheme.bodyMedium?.copyWith(
    height: 1.5,
  );

  // MARK: - Common Padding Presets
  EdgeInsets get screenPadding => AppInsets.screenPadding;
  EdgeInsets get cardPadding => AppInsets.cardPadding;
  EdgeInsets get buttonPadding => AppInsets.buttonPadding;
  EdgeInsets get listItemPadding => AppInsets.listItemPadding;

  // MARK: - Animation Durations
  Duration get fastAnimation => const Duration(milliseconds: AppSizes.animationFast);
  Duration get mediumAnimation => const Duration(milliseconds: AppSizes.animationMedium);
  Duration get slowAnimation => const Duration(milliseconds: AppSizes.animationSlow);

  // MARK: - Health-specific Utilities
  Color getBMITextColor(double bmi) {
    final bmiColor = getBMIColor(bmi);
    return bmiColor.hasGoodContrast(healthSurface) ? bmiColor : healthOnSurface;
  }

  Color getHealthStatusColor(String status, {double opacity = 1.0}) {
    Color baseColor;
    switch (status.toLowerCase()) {
      case 'excellent':
      case 'good':
      case 'normal':
        baseColor = healthSuccess;
        break;
      case 'caution':
      case 'warning':
      case 'overweight':
        baseColor = healthWarning;
        break;
      case 'danger':
      case 'obese':
      case 'critical':
        baseColor = healthError;
        break;
      default:
        baseColor = healthInfo;
    }
    return baseColor.withOpacity(opacity);
  }

  LinearGradient getHealthGradient([Color? startColor, Color? endColor]) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        startColor ?? healthPrimary,
        endColor ?? healthSecondary,
      ],
    );
  }

  // MARK: - Button Styles
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: healthPrimary,
    foregroundColor: Colors.white,
    padding: buttonPadding,
    shape: RoundedRectangleBorder(borderRadius: buttonRadius),
    elevation: 0,
  );

  ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: healthPrimary,
    padding: buttonPadding,
    shape: RoundedRectangleBorder(borderRadius: buttonRadius),
    side: BorderSide(color: healthPrimary, width: 1.5),
  );

  ButtonStyle get subtleButtonStyle => TextButton.styleFrom(
    foregroundColor: healthPrimary,
    padding: buttonPadding,
    shape: RoundedRectangleBorder(borderRadius: buttonRadius),
  );
}

/// Riverpod provider for ThemeService
final themeServiceProvider = Provider<ThemeService>((ref) {
  // This will be overridden in the widget tree with actual context
  throw UnimplementedError('ThemeService must be provided with context');
});

/// Extension to easily access ThemeService from context
extension ThemeServiceExtension on BuildContext {
  ThemeService get themeService => ThemeService.fromContext(this);
}

/// Simplified extensions for commonly used properties
extension QuickThemeAccess on BuildContext {
  // Quick color access
  Color get primaryColor => themeService.healthPrimary;
  Color get surfaceColor => themeService.healthSurface;
  Color get onSurfaceColor => themeService.healthOnSurface;
  
  // Quick spacing access
  double get spacing => themeService.spaceMedium;
  double get spacingLarge => themeService.spaceLarge;
  
  // Quick padding access
  EdgeInsets get padding => themeService.screenPadding;
  EdgeInsets get cardPadding => themeService.cardPadding;
  
  // Quick radius access
  BorderRadius get radius => themeService.radiusMedium;
  BorderRadius get cardRadius => themeService.cardRadius;
}
