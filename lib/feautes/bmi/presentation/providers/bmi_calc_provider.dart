import 'package:bmi_calculator/feautes/bmi/data/entities/bmi_result.dart';
import 'package:bmi_calculator/feautes/bmi/data/usecases/calculate_bmi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bmi_input_provider.dart';

final calculateBMIUseCaseProvider = Provider<CalculateBMIUseCase>((ref) => CalculateBMIUseCase());

final bmiResultProvider = Provider<BMIResult?>((ref) {
  final input = ref.watch(bmiInputProvider);
  final useCase = ref.watch(calculateBMIUseCaseProvider);
  return useCase(input);
});