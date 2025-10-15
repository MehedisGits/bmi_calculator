import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/size.dart';

/// Component theme builders for health applications
/// Provides consistent theming for all UI components
class HealthComponentThemes {
  HealthComponentThemes._();

  static const String _fontPrimary = 'Inter';

  // MARK: - App Bar Theme
  static AppBarTheme buildAppBarTheme(ThemeData base, bool isDark) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: base.colorScheme.surface,
      foregroundColor: base.colorScheme.onSurface,
      titleTextStyle: base.textTheme.headlineMedium,
      toolbarHeight: AppSizes.appBarHeight,
      systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  // MARK: - Input Decoration Theme
  static InputDecorationTheme buildInputTheme(ThemeData base, bool isDark) {
    return InputDecorationTheme(
      filled: true,
      fillColor: base.colorScheme.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLarge,
        vertical: AppSizes.paddingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        borderSide: BorderSide(
          color: base.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        borderSide: BorderSide(
          color: base.colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        borderSide: BorderSide(
          color: base.colorScheme.error,
          width: 1,
        ),
      ),
      labelStyle: TextStyle(
        color: base.colorScheme.onSurfaceVariant,
        fontSize: AppSizes.textLabel,
      ),
      hintStyle: TextStyle(
        color: base.colorScheme.onSurfaceVariant.withOpacity(0.6),
        fontSize: AppSizes.textBody,
      ),
    );
  }

  // MARK: - Card Theme
  static CardThemeData buildCardTheme(ThemeData base, bool isDark) {
    return CardThemeData(
      elevation: 0,
      color: base.colorScheme.surfaceContainerLowest,
      shadowColor: base.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: BorderSide(
          color: base.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(AppSizes.paddingSmall),
    );
  }

  // MARK: - Button Themes
  static ElevatedButtonThemeData buildElevatedButtonTheme(ThemeData base, bool isDark) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingXLarge,
          vertical: AppSizes.paddingMedium,
        ),
        minimumSize: const Size(0, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        textStyle: TextStyle(
          fontFamily: _fontPrimary,
          fontSize: AppSizes.textButton,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static FilledButtonThemeData buildFilledButtonTheme(ThemeData base, bool isDark) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLarge,
          vertical: AppSizes.paddingMedium,
        ),
        minimumSize: const Size(0, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        textStyle: TextStyle(
          fontFamily: _fontPrimary,
          fontSize: AppSizes.textButton,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData buildOutlinedButtonTheme(ThemeData base, bool isDark) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLarge,
          vertical: AppSizes.paddingMedium,
        ),
        minimumSize: const Size(0, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        side: BorderSide(
          color: base.colorScheme.outline,
          width: 1.5,
        ),
        textStyle: TextStyle(
          fontFamily: _fontPrimary,
          fontSize: AppSizes.textButton,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static TextButtonThemeData buildTextButtonTheme(ThemeData base, bool isDark) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        minimumSize: const Size(0, AppSizes.buttonHeightSmall),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        textStyle: TextStyle(
          fontFamily: _fontPrimary,
          fontSize: AppSizes.textButton,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // MARK: - Chip Theme
  static ChipThemeData buildChipTheme(ThemeData base, bool isDark) {
    return base.chipTheme.copyWith(
      side: BorderSide.none,
      elevation: 0,
      pressElevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      labelStyle: TextStyle(
        fontFamily: _fontPrimary,
        fontSize: AppSizes.textCaption,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // MARK: - Slider Theme
  static SliderThemeData buildSliderTheme(ThemeData base, bool isDark) {
    return SliderThemeData(
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 12,
        elevation: 2,
      ),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
      activeTrackColor: base.colorScheme.primary,
      inactiveTrackColor: base.colorScheme.primary.withOpacity(0.3),
      thumbColor: base.colorScheme.primary,
      overlayColor: base.colorScheme.primary.withOpacity(0.1),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: base.colorScheme.primary,
      valueIndicatorTextStyle: TextStyle(
        color: base.colorScheme.onPrimary,
        fontSize: AppSizes.textCaption,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // MARK: - Progress Indicator Theme
  static ProgressIndicatorThemeData buildProgressTheme(ThemeData base, bool isDark) {
    return ProgressIndicatorThemeData(
      color: base.colorScheme.primary,
      linearTrackColor: base.colorScheme.primary.withOpacity(0.2),
      circularTrackColor: base.colorScheme.primary.withOpacity(0.2),
    );
  }

  // MARK: - Bottom Sheet Theme
  static BottomSheetThemeData buildBottomSheetTheme(ThemeData base, bool isDark) {
    return BottomSheetThemeData(
      backgroundColor: base.colorScheme.surface,
      elevation: 8,
      modalElevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXLarge),
        ),
      ),
      constraints: const BoxConstraints(
        maxWidth: AppSizes.maxWidthMobile,
      ),
    );
  }

  // MARK: - Snackbar Theme
  static SnackBarThemeData buildSnackBarTheme(ThemeData base, bool isDark) {
    return SnackBarThemeData(
      backgroundColor: base.colorScheme.inverseSurface,
      contentTextStyle: TextStyle(
        color: base.colorScheme.onInverseSurface,
        fontSize: AppSizes.textBody,
        fontFamily: _fontPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    );
  }
}
