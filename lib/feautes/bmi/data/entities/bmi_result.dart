import 'package:flutter/material.dart';

import 'bmi_input.dart';

class BMIResult {
  final double bmi;
  final BMICategory category;
  final String message;
  final String detailedAnalysis;
  final List<HealthTip> healthTips;
  final BMIInput input;
  final DateTime calculatedAt;

  const BMIResult({
    required this.bmi,
    required this.category,
    required this.message,
    required this.healthTips,
    required this.input,
    required this.detailedAnalysis,
    required this.calculatedAt,
  });

  String get formattedBMI => bmi.toStringAsFixed(1);

  String get formattedCategory => category.label;

  String get formattedMessage => message;

  String get formattedDetailedAnalysis => detailedAnalysis;

  String get formattedHealthTips => healthTips.map((tip) => '${tip.emoji} ${tip.title}: ${tip.description}').join('\n');

  String get formattedInput => input.toString();

  String get formattedCalculatedAt => calculatedAt.toString();
}

enum BMICategory {
  severelyUnderweight('Severely Underweight', '<16.0', Color(0xFF1565C0), '😰'),
  underweight('Underweight', '16.0-18.4', Color(0xFF42A5F5), '😕'),
  normal('Normal Weight', '18.5-24.9', Color(0xFF66BB6A), '😊'),
  overweight('Overweight', '25.0-29.9', Color(0xFFFF9800), '😐'),
  moderatelyObese('Moderately Obese', '30.0-34.9', Color(0xFFFF5722), '😟'),
  severelyObese('Severely Obese', '35.0-39.9', Color(0xFFD32F2F), '😰'),
  verySeverelyObese('Very Severely Obese', '≥40.0', Color(0xFF8E24AA), '🆘');

  const BMICategory(this.label, this.range, this.color, this.emoji);

  final String label;
  final String range;
  final Color color;
  final String emoji;

  static BMICategory fromBMI(double bmi) {
    if (bmi <16.0) return BMICategory.severelyUnderweight;
    if (bmi <18.5) return BMICategory.underweight;
    if (bmi <25.0) return BMICategory.normal;
    if (bmi <30.0) return BMICategory.overweight;
    if (bmi <35.0) return BMICategory.moderatelyObese;
    if (bmi <40.0) return BMICategory.severelyObese;
    return BMICategory.verySeverelyObese;
  }
}


class HealthTip {
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final HealthTipCategory category;

  const HealthTip({
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    required this.category,
  });
}

enum HealthTipCategory {
  nutrition,
  exercise,
  lifestyle,
  sleep,
  stress,
  weightManagement, medical,
}