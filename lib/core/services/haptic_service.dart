import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Haptic feedback service interface for testability and abstraction
abstract class IHapticService {
  void light();
  void medium();
  void heavy();
  void success();
  void warning();
  void error();
  void selection();
  void impact();
}

/// Implementation of haptic service using Flutter's HapticFeedback
class HapticService implements IHapticService {
  @override
  void light() {
    HapticFeedback.lightImpact();
  }

  @override
  void medium() {
    HapticFeedback.mediumImpact();
  }

  @override
  void heavy() {
    HapticFeedback.heavyImpact();
  }

  @override
  void success() {
    // Use medium impact for success (positive feedback)
    HapticFeedback.mediumImpact();
  }

  @override
  void warning() {
    // Use light impact for warnings (gentle attention)
    HapticFeedback.lightImpact();
  }

  @override
  void error() {
    // Use heavy impact for errors (strong attention)
    HapticFeedback.heavyImpact();
  }

  @override
  void selection() {
    HapticFeedback.selectionClick();
  }

  @override
  void impact() {
    HapticFeedback.mediumImpact();
  }
}

/// Mock haptic service for testing
class MockHapticService implements IHapticService {
  final List<String> _calls = [];
  
  List<String> get calls => List.unmodifiable(_calls);
  
  void clearCalls() => _calls.clear();

  @override
  void light() => _calls.add('light');

  @override
  void medium() => _calls.add('medium');

  @override
  void heavy() => _calls.add('heavy');

  @override
  void success() => _calls.add('success');

  @override
  void warning() => _calls.add('warning');

  @override
  void error() => _calls.add('error');

  @override
  void selection() => _calls.add('selection');

  @override
  void impact() => _calls.add('impact');
}

/// Haptic service provider
final hapticServiceProvider = Provider<IHapticService>((ref) {
  return HapticService();
});

/// Extension for easier access in widgets
extension HapticExtension on WidgetRef {
  IHapticService get haptic => read(hapticServiceProvider);
}

/// Context for common haptic patterns in BMI app
class BMIHapticPatterns {
  final IHapticService _haptic;
  
  BMIHapticPatterns(this._haptic);
  
  /// Feedback for input value changes
  void inputChange() => _haptic.light();
  
  /// Feedback for gender selection
  void genderSelection() => _haptic.medium();
  
  /// Feedback for calculate button press
  void calculatePress() => _haptic.medium();
  
  /// Feedback for successful BMI calculation
  void calculationComplete() => _haptic.success();
  
  /// Feedback for slider interaction
  void sliderMove() => _haptic.selection();
  
  /// Feedback for reaching input limits
  void limitReached() => _haptic.warning();
  
  /// Feedback for validation errors
  void validationError() => _haptic.error();
  
  /// Feedback for button tap
  void buttonTap() => _haptic.impact();
}
