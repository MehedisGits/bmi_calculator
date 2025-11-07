import 'package:flutter/material.dart';

/// Comprehensive sizing system for responsive health applications
/// Based on Material 3 guidelines and health app UX best practices
class AppSizes {
  AppSizes._();

  // MARK: - Breakpoints
  /// Responsive breakpoints for different screen sizes
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // MARK: - Screen Constraints
  /// Maximum width constraints for different form factors
  static const double maxWidthMobile = 480;
  static const double maxWidthTablet = 768;
  static const double maxWidthDesktop = 1200;

  // MARK: - Spacing System
  /// 8-point spacing system for consistent layouts
  static const double spaceXXS = 2;
  static const double spaceXS = 4;
  static const double spaceSmall = 8;
  static const double spaceMedium = 16;
  static const double spaceLarge = 24;
  static const double spaceXLarge = 32;
  static const double spaceXXLarge = 48;
  static const double spaceHuge = 64;

  // MARK: - Padding System
  /// Consistent padding values for components
  static const double paddingXXS = 2;
  static const double paddingXS = 4;
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;
  static const double paddingXLarge = 32;
  static const double paddingXXLarge = 48;

  // MARK: - Margin System
  /// Consistent margin values for layouts
  static const double marginXS = 4;
  static const double marginSmall = 8;
  static const double marginMedium = 16;
  static const double marginLarge = 24;
  static const double marginXLarge = 32;

  // MARK: - Border Radius
  /// Consistent border radius for different components
  static const double radiusXXS = 2;
  static const double radiusXSmall = 4;
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;
  static const double radiusXXLarge = 32;
  static const double radiusRound = 100;

  // MARK: - Border Width
  /// Consistent border widths
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthThick = 1.5;
  static const double borderWidthThickest = 2.0;

  // MARK: - Component Heights
  /// Standard heights for interactive components
  static const double buttonHeightXSmall = 32;
  static const double buttonHeightSmall = 40;
  static const double buttonHeight = 48;
  static const double buttonHeightLarge = 56;
  static const double buttonHeightXLarge = 64;
  static const double inputHeight = 56;
  static const double cardHeightSmall = 80;
  static const double cardHeightMedium = 120;
  static const double cardHeightLarge = 200;
  static const double appBarHeight = 64;

  // MARK: - Typography Sizes
  /// Health-optimized typography scale
  static const double textHero = 40; // BMI score display
  static const double textDisplay = 32; // Large displays
  static const double textHeading = 24; // Section headers
  static const double textSubheading = 20; // Subsection headers
  static const double textTitle = 18; // Card titles
  static const double textSubtitle = 16; // Card subtitles
  static const double textBody = 16; // Body text
  static const double textBodyMedium = 14; // Medium body text
  static const double textButton = 16; // Button text
  static const double textCaption = 12; // Captions and labels
  static const double textLabel = 14; // Form labels
  static const double textLabelSmall = 12; // Small labels

  // MARK: - Icon Sizes
  /// Consistent icon sizing
  static const double iconXS = 16;
  static const double iconSmall = 20;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 40;
  static const double iconHuge = 48;

  // MARK: - Touch Targets
  /// Minimum touch target sizes for accessibility
  static const double minTouchTarget = 44; // iOS minimum
  static const double recommendedTouchTarget = 48; // Material recommendation
  static const double touchTargetSpacing = 8; // Minimum spacing between targets

  // MARK: - Health-specific Sizes
  /// Sizes specific to health applications
  
  /// BMI result display
  static const double bmiScoreSize = 80;
  static const double bmiCategorySize = 120;
  static const double bmiChartHeight = 200;
  
  /// Health tips cards
  static const double healthTipCardHeight = 100;
  static const double healthTipIconSize = 32;
  
  /// Input controls
  static const double sliderHeight = 60;
  static const double counterSize = 48;
  static const double genderSelectorHeight = 100;

  // MARK: - Animation Durations
  /// Standard animation durations in milliseconds
  static const int animationFast = 150;
  static const int animationMedium = 300;
  static const int animationSlow = 500;
  static const int animationVerySlow = 800;

  // MARK: - Elevation System
  /// Material 3 elevation levels
  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 3;
  static const double elevation3 = 6;
  static const double elevation4 = 8;
  static const double elevation5 = 12;

  // MARK: - Grid System
  /// Responsive grid configuration
  static const int mobileColumns = 4;
  static const int tabletColumns = 8;
  static const int desktopColumns = 12;
  static const double gridGutter = 16;

  // MARK: - Health Chart Dimensions
  /// Specific dimensions for health data visualization
  static const double chartHeight = 300;
  static const double chartHeightSmall = 200;
  static const double chartHeightLarge = 400;
  static const double chartPadding = 20;
  static const double chartLegendHeight = 40;

  // MARK: - Modal and Dialog Sizes
  /// Standard sizes for overlays and dialogs
  static const double modalMaxWidth = 400;
  static const double modalMaxHeight = 600;
  static const double dialogPadding = 24;
  static const double sheetHeaderHeight = 56;

  // MARK: - List and Card Spacing
  /// Spacing for lists and card layouts
  static const double listItemHeight = 72;
  static const double listItemPadding = 16;
  static const double cardSpacing = 12;
  static const double sectionSpacing = 32;
}

/// Responsive size utilities
class ResponsiveSizes {
  ResponsiveSizes._();

  /// Get responsive padding based on screen width
  static double getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppSizes.mobileBreakpoint) {
      return AppSizes.paddingMedium;
    } else if (width < AppSizes.tabletBreakpoint) {
      return AppSizes.paddingLarge;
    } else {
      return AppSizes.paddingXLarge;
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width < AppSizes.mobileBreakpoint ? 0.9 : 1.0;
    return baseSize * scaleFactor;
  }

  /// Get responsive column count for grids
  static int getResponsiveColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppSizes.mobileBreakpoint) {
      return AppSizes.mobileColumns;
    } else if (width < AppSizes.tabletBreakpoint) {
      return AppSizes.tabletColumns;
    } else {
      return AppSizes.desktopColumns;
    }
  }

  /// Get responsive card width
  static double getResponsiveCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppSizes.mobileBreakpoint) {
      return width - (AppSizes.paddingMedium * 2);
    } else if (width < AppSizes.tabletBreakpoint) {
      return (width - (AppSizes.paddingLarge * 3)) / 2;
    } else {
      return (width - (AppSizes.paddingXLarge * 4)) / 3;
    }
  }

  /// Get responsive maximum content width
  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppSizes.mobileBreakpoint) {
      return AppSizes.maxWidthMobile;
    } else if (width < AppSizes.tabletBreakpoint) {
      return AppSizes.maxWidthTablet;
    } else {
      return AppSizes.maxWidthDesktop;
    }
  }
}

/// Edge insets presets for common use cases
class AppInsets {
  AppInsets._();

  // MARK: - Common Padding Presets
  static const EdgeInsets allXS = EdgeInsets.all(AppSizes.paddingXS);
  static const EdgeInsets allSmall = EdgeInsets.all(AppSizes.paddingSmall);
  static const EdgeInsets allMedium = EdgeInsets.all(AppSizes.paddingMedium);
  static const EdgeInsets allLarge = EdgeInsets.all(AppSizes.paddingLarge);
  static const EdgeInsets allXLarge = EdgeInsets.all(AppSizes.paddingXLarge);

  // MARK: - Horizontal Padding
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(horizontal: AppSizes.paddingXS);
  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall);
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium);
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge);
  static const EdgeInsets horizontalXLarge = EdgeInsets.symmetric(horizontal: AppSizes.paddingXLarge);

  // MARK: - Vertical Padding
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(vertical: AppSizes.paddingXS);
  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: AppSizes.paddingSmall);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: AppSizes.paddingMedium);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: AppSizes.paddingLarge);
  static const EdgeInsets verticalXLarge = EdgeInsets.symmetric(vertical: AppSizes.paddingXLarge);

  // MARK: - Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.all(AppSizes.paddingMedium);
  static const EdgeInsets screenPaddingLarge = EdgeInsets.all(AppSizes.paddingLarge);

  // MARK: - Card Padding
  static const EdgeInsets cardPadding = EdgeInsets.all(AppSizes.paddingLarge);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(AppSizes.paddingMedium);

  // MARK: - Button Padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSizes.paddingLarge,
    vertical: AppSizes.paddingMedium,
  );
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: AppSizes.paddingMedium,
    vertical: AppSizes.paddingSmall,
  );

  // MARK: - List Item Padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: AppSizes.paddingMedium,
    vertical: AppSizes.paddingSmall,
  );

  // MARK: - Bottom Safe Area
  static EdgeInsets bottomSafeArea(BuildContext context) {
    return EdgeInsets.only(
      bottom: MediaQuery.of(context).padding.bottom + AppSizes.paddingMedium,
    );
  }

  // MARK: - Top Safe Area
  static EdgeInsets topSafeArea(BuildContext context) {
    return EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + AppSizes.paddingMedium,
    );
  }
}

/// Border radius presets for common components
class AppRadius {
  AppRadius._();

  // MARK: - Common Radius
  static const BorderRadius small = BorderRadius.all(Radius.circular(AppSizes.radiusSmall));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(AppSizes.radiusMedium));
  static const BorderRadius large = BorderRadius.all(Radius.circular(AppSizes.radiusLarge));
  static const BorderRadius xLarge = BorderRadius.all(Radius.circular(AppSizes.radiusXLarge));

  // MARK: - Component-specific Radius
  static const BorderRadius button = BorderRadius.all(Radius.circular(AppSizes.radiusMedium));
  static const BorderRadius card = BorderRadius.all(Radius.circular(AppSizes.radiusLarge));
  static const BorderRadius input = BorderRadius.all(Radius.circular(AppSizes.radiusMedium));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(AppSizes.radiusSmall));

  // MARK: - Modal and Sheet Radius
  static const BorderRadius modalTop = BorderRadius.vertical(
    top: Radius.circular(AppSizes.radiusXLarge),
  );
  static const BorderRadius modalBottom = BorderRadius.vertical(
    bottom: Radius.circular(AppSizes.radiusXLarge),
  );

  // MARK: - Health-specific Radius
  static const BorderRadius bmiCard = BorderRadius.all(Radius.circular(AppSizes.radiusXLarge));
  static const BorderRadius healthTip = BorderRadius.all(Radius.circular(AppSizes.radiusMedium));
}
