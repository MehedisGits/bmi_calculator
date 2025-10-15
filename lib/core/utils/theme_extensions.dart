import 'package:flutter/material.dart';
import '../constants/size.dart';

/// Legacy extension methods - use ThemeService instead for new code
/// Kept for backward compatibility during migration
@Deprecated('Use ThemeService instead for better centralization')
extension LegacyThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

/// Health-themed color extensions
extension HealthColorUtils on Color {
  
  /// Get a health-appropriate variant of the color
  Color get healthVariant {
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation(
      (hsl.saturation * 0.8).clamp(0.0, 1.0)
    ).withLightness(
      (hsl.lightness * 1.1).clamp(0.0, 1.0)
    ).toColor();
  }
  
  /// Create a subtle background variant
  Color get subtleBackground => withOpacity(0.1);
  
  /// Create a strong accent variant
  Color get strongAccent => withOpacity(0.8);
  
  /// Get contrasting text color
  Color get contrastingText {
    return computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}

/// Widget extension for health-themed styling
extension HealthWidgetExtensions on Widget {
  
  /// Add animated appearance with health styling
  Widget withHealthAnimation({
    Duration? duration,
    Curve? curve,
    Offset? begin,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? const Duration(milliseconds: AppSizes.animationMedium),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve ?? Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset.lerp(begin ?? const Offset(0, 20), Offset.zero, value)!,
          child: Opacity(
            opacity: value,
            child: this,
          ),
        );
      },
    );
  }
}
