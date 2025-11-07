import 'package:flutter/material.dart';
import '../services/theme_service.dart';

/// Reusable gradient container following consistent design patterns
/// Eliminates repetition of gradient decoration code
class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;

  const GradientContainer({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.borderRadius,
    this.margin,
    this.padding,
    this.boxShadow,
    this.width,
    this.height,
  });

  /// Health-themed gradient container
  factory GradientContainer.health({
    Key? key,
    required Widget child,
    required ThemeService theme,
    double opacity = 1.0,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
    List<BoxShadow>? boxShadow,
    double? width,
    double? height,
  }) {
    return GradientContainer(
      key: key,
      colors: [
        theme.healthPrimary.withOpacity(opacity),
        theme.healthSecondary.withOpacity(opacity * 0.8),
      ],
      child: child,
      borderRadius: borderRadius,
      margin: margin,
      padding: padding,
      boxShadow: boxShadow,
      width: width,
      height: height,
    );
  }

  /// Subtle health gradient (low opacity)
  factory GradientContainer.healthSubtle({
    Key? key,
    required Widget child,
    required ThemeService theme,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) {
    return GradientContainer(
      key: key,
      colors: [
        theme.healthPrimary.withOpacity(0.08),
        theme.healthSecondary.withOpacity(0.04),
        Colors.white.withOpacity(0.95),
      ],
      borderRadius: borderRadius ?? theme.borderRadiusMedium,
      margin: margin,
      padding: padding ?? EdgeInsets.all(theme.paddingLarge),
      boxShadow: [
        BoxShadow(
          color: theme.healthPrimary.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin!,
          end: end!,
          colors: colors,
        ),
        borderRadius: borderRadius ?? theme.borderRadiusSmall,
        boxShadow: boxShadow,
      ),
      child: child,
    );

    return container;
  }
}

