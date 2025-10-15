import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../feautes/bmi/data/entities/bmi_input.dart';

/// Configuration class for BMI-related constants and limits
class BMIConfig {
  const BMIConfig._();

  // Input Limits
  static const BMILimits heightLimits = BMILimits(
    min: 100.0,
    max: 220.0,
    step: 1.0,
    unit: 'cm',
  );

  static const BMILimits weightLimits = BMILimits(
    min: 30.0,
    max: 300.0,
    step: 0.5,
    unit: 'kg',
  );

  static const BMILimits ageLimits = BMILimits(
    min: 1.0,
    max: 120.0,
    step: 1.0,
    unit: 'years',
  );

  // Default Values
  static const BMIDefaults defaults = BMIDefaults(
    height: 170.0,
    weight: 70.0,
    age: 25,
    gender: Gender.male,
  );

  // BMI Category Ranges
  static const BMIRanges ranges = BMIRanges(
    severelyUnderweight: BMIRange(min: 0.0, max: 16.0),
    underweight: BMIRange(min: 16.0, max: 18.5),
    normal: BMIRange(min: 18.5, max: 25.0),
    overweight: BMIRange(min: 25.0, max: 30.0),
    moderatelyObese: BMIRange(min: 30.0, max: 35.0),
    severelyObese: BMIRange(min: 35.0, max: 40.0),
    verySeverelyObese: BMIRange(min: 40.0, max: double.infinity),
  );

  // Animation Durations (ms)
  static const AnimationConfig animations = AnimationConfig(
    fast: 200,
    medium: 400,
    slow: 800,
    veryFast: 100,
    verySlow: 1200,
  );

  // UI Configuration
  static const UIConfig ui = UIConfig(
    previewDelay: 1200, // ms before showing BMI preview
    debounceDelay: 300,  // ms for input debouncing
    maxFileSize: 5,      // MB for image uploads (future)
    maxHistoryEntries: 50, // Maximum BMI history entries
  );

  // Health Insights Configuration
  static const InsightsConfig insights = InsightsConfig(
    maxTipsPerCategory: 3,
    tipRotationDays: 7,
    enablePersonalization: true,
    includeAgeSpecificTips: true,
  );
}

/// Input limits configuration
class BMILimits {
  final double min;
  final double max;
  final double step;
  final String unit;

  const BMILimits({
    required this.min,
    required this.max,
    required this.step,
    required this.unit,
  });

  /// Check if value is within valid range
  bool isValid(double value) => value >= min && value <= max;

  /// Clamp value to valid range
  double clamp(double value) => value.clamp(min, max);

  /// Get next valid step value
  double nextStep(double current) {
    final next = current + step;
    return next > max ? max : next;
  }

  /// Get previous valid step value
  double previousStep(double current) {
    final previous = current - step;
    return previous < min ? min : previous;
  }
}

/// Default input values
class BMIDefaults {
  final double height;
  final double weight;
  final int age;
  final Gender gender;

  const BMIDefaults({
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
  });

  /// Convert defaults to BMIInput entity
  BMIInput toInput() {
    return BMIInput(
      height: height,
      weight: weight,
      age: age,
      gender: gender,
    );
  }
}

/// BMI category ranges
class BMIRanges {
  final BMIRange severelyUnderweight;
  final BMIRange underweight;
  final BMIRange normal;
  final BMIRange overweight;
  final BMIRange moderatelyObese;
  final BMIRange severelyObese;
  final BMIRange verySeverelyObese;

  const BMIRanges({
    required this.severelyUnderweight,
    required this.underweight,
    required this.normal,
    required this.overweight,
    required this.moderatelyObese,
    required this.severelyObese,
    required this.verySeverelyObese,
  });
}

/// Individual BMI range
class BMIRange {
  final double min;
  final double max;

  const BMIRange({required this.min, required this.max});

  bool contains(double bmi) => bmi >= min && bmi < max;
}

/// Animation timing configuration
class AnimationConfig {
  final int fast;
  final int medium;
  final int slow;
  final int veryFast;
  final int verySlow;

  const AnimationConfig({
    required this.fast,
    required this.medium,
    required this.slow,
    required this.veryFast,
    required this.verySlow,
  });

  Duration get fastDuration => Duration(milliseconds: fast);
  Duration get mediumDuration => Duration(milliseconds: medium);
  Duration get slowDuration => Duration(milliseconds: slow);
  Duration get veryFastDuration => Duration(milliseconds: veryFast);
  Duration get verySlowDuration => Duration(milliseconds: verySlow);
}

/// UI behavior configuration
class UIConfig {
  final int previewDelay;
  final int debounceDelay;
  final int maxFileSize;
  final int maxHistoryEntries;

  const UIConfig({
    required this.previewDelay,
    required this.debounceDelay,
    required this.maxFileSize,
    required this.maxHistoryEntries,
  });

  Duration get previewDelayDuration => Duration(milliseconds: previewDelay);
  Duration get debounceDelayDuration => Duration(milliseconds: debounceDelay);
}

/// Health insights configuration
class InsightsConfig {
  final int maxTipsPerCategory;
  final int tipRotationDays;
  final bool enablePersonalization;
  final bool includeAgeSpecificTips;

  const InsightsConfig({
    required this.maxTipsPerCategory,
    required this.tipRotationDays,
    required this.enablePersonalization,
    required this.includeAgeSpecificTips,
  });
}

/// Environment-specific configurations
enum BMIEnvironment { development, staging, production }

class EnvironmentConfig {
  static const BMIEnvironment current = BMIEnvironment.development;
  
  static bool get isDevelopment => current == BMIEnvironment.development;
  static bool get isStaging => current == BMIEnvironment.staging;
  static bool get isProduction => current == BMIEnvironment.production;
  
  static bool get enableDebugFeatures => isDevelopment;
  static bool get enableAnalytics => isProduction || isStaging;
  static bool get enableCrashReporting => isProduction;
}

/// Configuration provider for dependency injection
final bmiConfigProvider = Provider<BMIConfig>((ref) {
  return const BMIConfig._();
});

/// Extension for easier config access
extension ConfigExtension on WidgetRef {
  BMIConfig get config => read(bmiConfigProvider);
}
