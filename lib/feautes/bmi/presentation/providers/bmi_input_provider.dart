import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/bmi_config.dart';
import '../../../../core/services/haptic_service.dart';
import '../../data/entities/bmi_input.dart';

/// Enhanced BMI Input Provider with validation, haptic feedback, and configuration
class BMIInputNotifier extends Notifier<BMIInputState> {
  late final IHapticService _haptic;

  @override
  BMIInputState build() {
    _haptic = ref.read(hapticServiceProvider);
    
    return BMIInputState.initial(BMIConfig.defaults.toInput());
  }

  /// Update height with validation and feedback
  void updateHeight(double height) {
    final limits = BMIConfig.heightLimits;
    
    if (!limits.isValid(height)) {
      _haptic.warning();
      _updateError('Height must be between ${limits.min} and ${limits.max} ${limits.unit}');
      return;
    }

    _haptic.light();
    final clampedHeight = limits.clamp(height);
    
    state = state.copyWith(
      input: state.input.copyWith(height: clampedHeight),
      error: null,
      lastUpdated: DateTime.now(),
    );
  }

  /// Update weight with validation and feedback
  void updateWeight(double weight) {
    final limits = BMIConfig.weightLimits;
    
    if (!limits.isValid(weight)) {
      _haptic.warning();
      _updateError('Weight must be between ${limits.min} and ${limits.max} ${limits.unit}');
      return;
    }

    _haptic.light();
    final clampedWeight = limits.clamp(weight);
    
    state = state.copyWith(
      input: state.input.copyWith(weight: clampedWeight),
      error: null,
      lastUpdated: DateTime.now(),
    );
  }

  /// Update age with validation and feedback
  void updateAge(int age) {
    final limits = BMIConfig.ageLimits;
    final ageDouble = age.toDouble();
    
    if (!limits.isValid(ageDouble)) {
      _haptic.warning();
      _updateError('Age must be between ${limits.min.round()} and ${limits.max.round()} years');
      return;
    }

    _haptic.light();
    final clampedAge = limits.clamp(ageDouble).round();
    
    state = state.copyWith(
      input: state.input.copyWith(age: clampedAge),
      error: null,
      lastUpdated: DateTime.now(),
    );
  }

  /// Update gender with haptic feedback
  void updateGender(Gender gender) {
    if (gender != state.input.gender) {
      _haptic.medium();
      state = state.copyWith(
        input: state.input.copyWith(gender: gender),
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Reset to default values
  void reset() {
    _haptic.success();
    state = BMIInputState.initial(BMIConfig.defaults.toInput());
  }

  /// Clear any error state
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(error: null);
    }
  }

  /// Validate all inputs
  bool validateAll() {
    final heightValid = BMIConfig.heightLimits.isValid(state.input.height);
    final weightValid = BMIConfig.weightLimits.isValid(state.input.weight);
    final ageValid = BMIConfig.ageLimits.isValid(state.input.age.toDouble());

    if (!heightValid || !weightValid || !ageValid) {
      _haptic.error();
      _updateError('Please check all input values');
      return false;
    }

    return true;
  }

  /// Get next step value for height
  double getNextHeightStep() {
    return BMIConfig.heightLimits.nextStep(state.input.height);
  }

  /// Get previous step value for height
  double getPreviousHeightStep() {
    return BMIConfig.heightLimits.previousStep(state.input.height);
  }

  /// Get next step value for weight
  double getNextWeightStep() {
    return BMIConfig.weightLimits.nextStep(state.input.weight);
  }

  /// Get previous step value for weight
  double getPreviousWeightStep() {
    return BMIConfig.weightLimits.previousStep(state.input.weight);
  }

  void _updateError(String message) {
    state = state.copyWith(
      error: BMIInputError(
        message: message,
        timestamp: DateTime.now(),
      ),
    );
  }
}

/// BMI Input State with error handling and metadata
class BMIInputState {
  final BMIInput input;
  final BMIInputError? error;
  final DateTime lastUpdated;
  final bool isModified;

  const BMIInputState({
    required this.input,
    this.error,
    required this.lastUpdated,
    required this.isModified,
  });

  /// Create initial state
  factory BMIInputState.initial(BMIInput defaultInput) {
    return BMIInputState(
      input: defaultInput,
      error: null,
      lastUpdated: DateTime.now(),
      isModified: false,
    );
  }

  /// Check if state has error
  bool get hasError => error != null;

  /// Check if inputs are valid
  bool get isValid => !hasError;

  /// Create copy with updated fields
  BMIInputState copyWith({
    BMIInput? input,
    BMIInputError? error,
    DateTime? lastUpdated,
    bool? isModified,
  }) {
    return BMIInputState(
      input: input ?? this.input,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isModified: isModified ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BMIInputState &&
        other.input == input &&
        other.error == error &&
        other.isModified == isModified;
  }

  @override
  int get hashCode {
    return Object.hash(input, error, isModified);
  }
}

/// BMI Input Error information
class BMIInputError {
  final String message;
  final DateTime timestamp;
  final String? field;

  const BMIInputError({
    required this.message,
    required this.timestamp,
    this.field,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BMIInputError &&
        other.message == message &&
        other.field == field;
  }

  @override
  int get hashCode => Object.hash(message, field);
}

/// Enhanced BMI Input Provider
final bmiInputProvider = NotifierProvider<BMIInputNotifier, BMIInputState>(
  BMIInputNotifier.new,
);

/// Convenience provider for just the input data
final bmiInputDataProvider = Provider<BMIInput>((ref) {
  return ref.watch(bmiInputProvider).input;
});

/// Provider for input validation status
final bmiInputValidationProvider = Provider<bool>((ref) {
  return ref.watch(bmiInputProvider).isValid;
});

/// Provider for input error messages
final bmiInputErrorProvider = Provider<String?>((ref) {
  return ref.watch(bmiInputProvider).error?.message;
});

/// Extension for easier access to bmi input provider
extension BMIInputExtension on WidgetRef {
  BMIInputNotifier get bmiInput => read(bmiInputProvider.notifier);
  BMIInputState get bmiInputState => read(bmiInputProvider);
}
