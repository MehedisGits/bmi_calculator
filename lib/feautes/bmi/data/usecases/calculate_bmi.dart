import 'package:bmi_calculator/feautes/bmi/data/entities/bmi_input.dart';
import 'package:bmi_calculator/feautes/bmi/data/entities/bmi_result.dart';

class CalculateBMIUseCase {
  BMIResult call(BMIInput input) {
    final heightMeters = input.height / 100;
    final bmi = input.weight / (heightMeters * heightMeters);
    final category = _getBMICategory(bmi);
    final message = _getBMIMessage(category);
    final healthTips = _getBMIHealthTips(category, input.age, input.gender);

    return BMIResult(
      bmi: bmi,
      category: category,
      message: message,
      healthTips: healthTips,
      input: input,
    );
  }

  BMICategory _getBMICategory(double bmi) {
    if (bmi < 18.5) return BMICategory.underweight;
    if (bmi >= 18.5 && bmi <= 24.9) return BMICategory.normal;
    if (bmi >= 25 && bmi <= 29.9) return BMICategory.overweight;
    return BMICategory.obese;
  }

  String _getBMIMessage(BMICategory category) {
    switch (category) {
      case BMICategory.underweight:
        return 'Your BMI suggests you may be underweight. Consider consulting with a healthcare provider.';
      case BMICategory.normal:
        return 'Great! Your BMI is in the healthy range. Keep up the good work!';
      case BMICategory.overweight:
        return 'Your BMI suggests you may be overweight. Consider adopting healthier lifestyle habits.';
      case BMICategory.obese:
        return 'Your BMI suggests obesity. We recommend consulting with a healthcare professional.';
    }
  }

  List<String> _getBMIHealthTips(BMICategory category, int age, Gender gender) {
    final baseTips = <String>[
      '💧 Drink at least 8 glasses of water daily',
      '🏃‍♀️ Aim for 150 minutes of moderate exercise weekly',
      '🥗 Include more fruits and vegetables in your diet',
      '😴 Get 7-9 hours of quality sleep each night',
    ];

    switch (category) {
      case BMICategory.underweight:
        return [
          ...baseTips,
          '🍳 Focus on increasing calorie intake through nutrient-rich foods',
          '💪 Consider strength training to build muscle mass',
          '🥜 Include healthy fats like nuts and avocados',
          '🍖 Increase protein intake with lean meats and legumes',
          '🏋️‍♀️ Consider strength training to build muscle mass',
        ];

      case BMICategory.normal:
        return [
          ...baseTips,
          '⚖️ Maintain your current healthy habits',
          '🧘‍♀️ Practice stress management techniques',
          '📊 Monitor your weight regularly',
          '🍳 Eat balanced meals and pay attention to portion sizes',
        ];
      case BMICategory.overweight:
        return [
          ...baseTips,
          '🍳 Pay attention to portion sizes and reduce calorie intake',
          '💪 Engage in regular physical activity to burn excess calories',
          '🥗 Include more fruits and vegetables in your diet',
          '😴 Get 7-9 hours of quality sleep each night',
        ];
      case BMICategory.obese:
        return [
          ...baseTips,
          '🍽️ Practice portion control',
          '🚶‍♀️ Start with light exercises like walking',
          '📱 Consider using a food diary app',
          '👨‍⚕️ Consult with a healthcare provider',
        ];
    }
  }
}
