import 'package:bmi_calculator/feautes/bmi/data/entities/bmi_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BMIInputNotifier extends Notifier<BMIInput> {
  @override
  BMIInput build() {
    return BMIInput(height: 170, weight: 70, age: 25, gender: Gender.male);
  }

  void updateHeight(double height) {
    state = state.copyWith(height: height);
  }

  void updateWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  void updateGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }
}

final bmiInputProvider = NotifierProvider<BMIInputNotifier, BMIInput>(
  BMIInputNotifier.new,
);
