import 'package:flutter/material.dart';

import 'bmi_input.dart';

enum BMICategory {
  underweight,
  normal,
  overweight,
  obese;

  String get label {
    switch (this) {
      case BMICategory.underweight:
        return 'Underweight';
      case BMICategory.normal:
        return 'Normal Weight';
      case BMICategory.overweight:
        return 'Overweight';
      case BMICategory.obese:
        return 'Obese';
    }
  }

  Color get color {
    switch (this) {
      case BMICategory.underweight:
        return Colors.blue;
      case BMICategory.normal:
        return Colors.green;
      case BMICategory.overweight:
        return Colors.orange;
      case BMICategory.obese:
        return Colors.red;
    }
  }
}

class BMIResult {
  final double bmi;
  final BMICategory category;
  final String message;
  final List<String> healthTips;
  final BMIInput input;

  const BMIResult({
    required this.bmi,
    required this.category,
    required this.message,
    required this.healthTips,
    required this.input,
  });
}