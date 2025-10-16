import 'package:bmi_calculator/core/services/theme_service.dart';
import 'package:flutter/material.dart';
import '../constants/size.dart';

/// Responsive layout utilities for building adaptive health applications
/// Provides screen size detection, responsive widgets, and layout helpers
class ResponsiveLayout extends StatelessWidget {
  /// The widget to display on mobile screens
  final Widget mobile;
  
  /// The widget to display on tablet screens (optional, defaults to mobile)
  final Widget? tablet;
  
  /// The widget to display on desktop screens (optional, defaults to tablet or mobile)
  final Widget? desktop;
  
  /// Custom breakpoints (optional, uses default if not provided)
  final double? mobileBreakpoint;
  final double? tabletBreakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileBreakpoint,
    this.tabletBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final mobileBreak = mobileBreakpoint ?? AppSizes.mobileBreakpoint;
    final tabletBreak = tabletBreakpoint ?? AppSizes.tabletBreakpoint;

    if (width >= tabletBreak && desktop != null) {
      return desktop!;
    } else if (width >= mobileBreak && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

/// Screen size detection utility
class ScreenSize {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppSizes.mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppSizes.mobileBreakpoint && width < AppSizes.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppSizes.tabletBreakpoint;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > AppSizes.desktopBreakpoint;
  }

  /// Get screen size category as enum
  static ScreenSizeCategory getCategory(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppSizes.mobileBreakpoint) {
      return ScreenSizeCategory.mobile;
    } else if (width < AppSizes.tabletBreakpoint) {
      return ScreenSizeCategory.tablet;
    } else {
      return ScreenSizeCategory.desktop;
    }
  }
}

/// Screen size categories
enum ScreenSizeCategory { mobile, tablet, desktop }

/// Responsive value provider - returns different values based on screen size
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T getValue(BuildContext context) {
    final category = ScreenSize.getCategory(context);
    switch (category) {
      case ScreenSizeCategory.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSizeCategory.tablet:
        return tablet ?? mobile;
      case ScreenSizeCategory.mobile:
        return mobile;
    }
  }
}

/// Responsive padding widget that adjusts padding based on screen size
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveValue<EdgeInsets>(
      mobile: mobile ?? AppInsets.screenPadding,
      tablet: tablet,
      desktop: desktop,
    ).getValue(context);

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// Responsive container with max width constraints
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final bool center;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxContentWidth = maxWidth ?? ResponsiveSizes.getMaxContentWidth(context);
    
    Widget content = Container(
      constraints: BoxConstraints(maxWidth: maxContentWidth),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: ResponsiveSizes.getResponsivePadding(context),
      ),
      child: child,
    );

    if (center) {
      content = Center(child: content);
    }

    return content;
  }
}

/// Responsive grid that adjusts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing = AppSizes.gridGutter,
    this.runSpacing = AppSizes.gridGutter,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveValue<int>(
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
    ).getValue(context);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      children: children,
    );
  }
}

/// Responsive text that scales font size based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = ResponsiveValue<double>(
      mobile: mobileSize ?? AppSizes.textBody,
      tablet: tabletSize,
      desktop: desktopSize,
    ).getValue(context);

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: responsiveFontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive spacing widget
class ResponsiveSpacing extends StatelessWidget {
  final double? mobile;
  final double? tablet;
  final double? desktop;
  final bool horizontal;

  const ResponsiveSpacing({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.horizontal = false,
  });

  /// Vertical spacing constructor
  const ResponsiveSpacing.vertical({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : horizontal = false;

  /// Horizontal spacing constructor
  const ResponsiveSpacing.horizontal({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : horizontal = true;

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveValue<double>(
      mobile: mobile ?? AppSizes.spaceMedium,
      tablet: tablet,
      desktop: desktop,
    ).getValue(context);

    return SizedBox(
      width: horizontal ? spacing : null,
      height: horizontal ? null : spacing,
    );
  }
}

/// Health-specific responsive layout for BMI calculator
class HealthLayout extends StatelessWidget {
  final Widget child;
  final bool showAppBar;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  const HealthLayout({
    super.key,
    required this.child,
    this.showAppBar = false,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: title != null ? Text(title!, style: context.themeService.textTheme.headlineSmall) : null,
              actions: actions,
              centerTitle: false,
            )
          : null,
      body: SafeArea(
        child: ResponsiveContainer(
          child: child,
        ),
      ),
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}

/// Responsive card layout for health information
class HealthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback? onTap;

  const HealthCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? EdgeInsets.all(
      ResponsiveSizes.getResponsivePadding(context),
    );

    Widget card = Card(
      color: color,
      child: Container(
        width: width,
        height: height,
        padding: responsivePadding,
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: card,
      );
    }

    return card;
  }
}

/// Responsive row that stacks on mobile
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool stackOnMobile;
  final double spacing;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.stackOnMobile = true,
    this.spacing = AppSizes.spaceMedium,
  });

  @override
  Widget build(BuildContext context) {
    if (stackOnMobile && ScreenSize.isMobile(context)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children
            .expand((child) => [child, SizedBox(height: spacing)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children
          .expand((child) => [child, SizedBox(width: spacing)])
          .take(children.length * 2 - 1)
          .toList(),
    );
  }
}

/// Extension methods for responsive utilities
extension ResponsiveExtensions on BuildContext {
  /// Quick access to screen size checks
  bool get isMobile => ScreenSize.isMobile(this);
  bool get isTablet => ScreenSize.isTablet(this);
  bool get isDesktop => ScreenSize.isDesktop(this);
  
  /// Quick access to responsive values
  double get responsivePadding => ResponsiveSizes.getResponsivePadding(this);
  int get responsiveColumns => ResponsiveSizes.getResponsiveColumns(this);
  double get maxContentWidth => ResponsiveSizes.getMaxContentWidth(this);
  
  /// Screen dimensions
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
