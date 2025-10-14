import 'package:bmi_calculator/feautes/bmi/data/entities/bmi_input.dart';
import 'package:bmi_calculator/feautes/bmi/data/entities/bmi_result.dart';
import 'package:flutter/material.dart';

class CalculateBMIUseCase {
  BMIResult call(BMIInput input) {
    final heightMeters = input.height / 100;
    final bmi = input.weight / (heightMeters * heightMeters);
    final category = BMICategory.fromBMI(bmi);
    final message = _getBMIMessage(category, input.gender);
    final detailedAnalysis = _getDetailedAnalysis(bmi, category, input);
    final healthTips = _getHealthTips(category, input.age, input.gender);

    return BMIResult(
      bmi: bmi,
      category: category,
      message: message,
      // FIX: Store full HealthTip objects, not just titles
      healthTips: healthTips,
      input: input,
      detailedAnalysis: detailedAnalysis,
      calculatedAt: DateTime.now(),
    );
  }

  String _getBMIMessage(BMICategory category, Gender gender) {
    final pronoun = gender == Gender.male ? 'his' : 'her';

    switch (category) {
      case BMICategory.severelyUnderweight:
        return 'Your BMI indicates severe underweight. Immediate medical consultation is strongly recommended to address potential health risks.';

      case BMICategory.underweight:
        return 'Your BMI suggests you may be underweight. Consider consulting with a healthcare provider for personalized advice.';

      case BMICategory.normal:
        return 'Excellent! Your BMI is in the healthy range. Keep maintaining $pronoun balanced lifestyle.';

      case BMICategory.overweight:
        return 'Your BMI indicates you may be overweight. Small lifestyle changes can help you reach a healthier weight.';

      case BMICategory.moderatelyObese:
        return 'Your BMI suggests moderate obesity. Consider adopting a structured approach to weight management with professional guidance.';

      case BMICategory.severelyObese:
        return 'Your BMI indicates severe obesity. Medical supervision for weight management is strongly recommended.';

      case BMICategory.verySeverelyObese:
        return 'Your BMI indicates very severe obesity. Immediate medical attention and comprehensive treatment plan are essential.';
    }
  }

  String _getDetailedAnalysis(
    double bmi,
    BMICategory category,
    BMIInput input,
  ) {
    final idealBMI = 22.0; // Middle of the healthy range
    final idealWeight = idealBMI * (input.height / 100) * (input.height / 100);
    final weightDifference = input.weight - idealWeight;

    String weightAdvice = '';
    if (weightDifference.abs() < 2) {
      weightAdvice =
          'Your weight is within 2kg of your ideal weight. Maintain your current healthy habits.';
    } else if (weightDifference > 0) {
      weightAdvice =
          'You are approximately ${weightDifference.toStringAsFixed(1)} kg above the ideal weight range.';
    } else {
      weightAdvice =
          'You are approximately ${(-weightDifference).toStringAsFixed(1)} kg below the ideal weight range.';
    }

    final ageFactors = _getSpecificAgeFactors(input.age);
    final genderFactors = _getSpecificGenderFactors(input.gender, input.age);

    // FIX: Use the actual healthy weight range method
    final healthyRange = _getHealthyWeightRange(input.height);

    return '$weightAdvice $ageFactors $genderFactors For your height of ${input.height.round()}cm, a healthy weight range would be $healthyRange.';
  }

  String _getHealthyWeightRange(double height) {
    final heightMeters = height / 100;
    final minWeight = 18.5 * heightMeters * heightMeters;
    final maxWeight = 24.9 * heightMeters * heightMeters;
    return '${minWeight.toStringAsFixed(1)}-${maxWeight.toStringAsFixed(1)} kg';
  }

  String _getSpecificAgeFactors(int age) {
    if (age < 18) {
      return 'As you are under 18, growth patterns may still be changing. Regular pediatric check-ups are important.';
    } else if (age < 25) {
      return 'At your age, establishing healthy habits now will benefit you long-term.';
    } else if (age < 40) {
      return 'This is an excellent time to focus on maintaining a healthy weight and active lifestyle.';
    } else if (age < 60) {
      return 'Metabolism may be slowing down, so maintaining muscle mass through strength training is particularly important.';
    } else {
      return 'Maintaining bone density and muscle mass becomes increasingly important with age.';
    }
  }

  String _getSpecificGenderFactors(Gender gender, int age) {
    if (gender == Gender.female) {
      if (age >= 18 && age <= 45) {
        return 'Women of reproductive age should ensure adequate nutrition for overall health.';
      } else if (age > 45) {
        return 'Post-menopausal women should pay special attention to bone health and cardiovascular fitness.';
      }
    } else {
      if (age >= 40) {
        return 'Men over 40 should monitor cardiovascular health and maintain muscle mass through regular exercise.';
      }
    }
    return 'Regular health check-ups and maintaining an active lifestyle are recommended.';
  }

  List<HealthTip> _getHealthTips(BMICategory category, int age, Gender gender) {
    final baseTips = <HealthTip>[
      HealthTip(
        title: 'Stay Hydrated',
        description:
            'Drink at least 8 glasses of water daily to support metabolism and overall health.',
        // FIX: Use consistent property name
        emoji: '💧',
        color: Colors.blue,
        category: HealthTipCategory.lifestyle,
      ),
      HealthTip(
        title: 'Regular Exercise',
        description:
            'Aim for 150 minutes of moderate-intensity exercise per week.',
        emoji: '🏃‍♀️',
        color: Colors.green,
        category: HealthTipCategory.exercise,
      ),
      HealthTip(
        title: 'Balanced Diet',
        description:
            'Include a variety of fruits, vegetables, lean proteins, and whole grains.',
        emoji: '🥗',
        color: Colors.orange,
        category: HealthTipCategory.nutrition,
      ),
      HealthTip(
        title: 'Quality Sleep',
        description:
            'Get 7-9 hours of quality sleep each night for optimal health.',
        emoji: '😴',
        color: Colors.purple,
        category: HealthTipCategory.lifestyle,
      ),
    ];

    final specificTips = _getCategorySpecificTips(category, age, gender);
    return [...baseTips, ...specificTips];
  }

  List<HealthTip> _getCategorySpecificTips(
    BMICategory category,
    int age,
    Gender gender,
  ) {
    switch (category) {
      case BMICategory.severelyUnderweight:
        return [
          HealthTip(
            title: 'Medical Consultation',
            description:
                'Seek immediate medical attention to identify and address underlying causes.',
            emoji: '🩺',
            color: Colors.red,
            category: HealthTipCategory.medical,
          ),
          HealthTip(
            title: 'Nutrient-Dense Foods',
            description:
                'Focus on calorie-dense, nutrient-rich foods like nuts, avocados, and healthy oils.',
            emoji: '🥑',
            color: Colors.green,
            category: HealthTipCategory.nutrition,
          ),
        ];

      case BMICategory.underweight:
        return [
          HealthTip(
            title: 'Increase Caloric Intake',
            description:
                'Add healthy calories through nuts, seeds, and protein-rich foods.',
            emoji: '🥜',
            color: Colors.brown,
            category: HealthTipCategory.nutrition,
          ),
          HealthTip(
            title: 'Strength Training',
            description:
                'Build muscle mass with resistance exercises 2-3 times per week.',
            emoji: '💪',
            color: Colors.red,
            category: HealthTipCategory.exercise,
          ),
          HealthTip(
            title: 'Frequent Meals',
            description:
                'Eat smaller, frequent meals throughout the day to increase total intake.',
            emoji: '🍽️',
            color: Colors.orange,
            category: HealthTipCategory.nutrition,
          ),
        ];

      case BMICategory.normal:
        return [
          HealthTip(
            title: 'Maintain Balance',
            description:
                'Continue your current healthy habits and lifestyle choices.',
            emoji: '⚖️',
            color: Colors.green,
            category: HealthTipCategory.lifestyle,
          ),
          HealthTip(
            title: 'Stress Management',
            description:
                'Practice stress-reduction techniques like meditation or yoga.',
            emoji: '🧘‍♀️',
            color: Colors.blue,
            category: HealthTipCategory.lifestyle,
          ),
          HealthTip(
            title: 'Regular Monitoring',
            description:
                'Check your weight monthly and maintain awareness of any changes.',
            emoji: '📊',
            color: Colors.teal,
            category: HealthTipCategory.lifestyle,
          ),
        ];

      case BMICategory.overweight:
        return [
          HealthTip(
            title: 'Portion Control',
            description:
                'Use smaller plates and be mindful of portion sizes to reduce caloric intake.',
            emoji: '🍽️',
            color: Colors.orange,
            category: HealthTipCategory.nutrition,
          ),
          HealthTip(
            title: 'Cardio Exercise',
            description:
                'Include 30 minutes of cardiovascular exercise most days of the week.',
            emoji: '🚴‍♀️',
            color: Colors.red,
            category: HealthTipCategory.exercise,
          ),
          HealthTip(
            title: 'Food Journal',
            description:
                'Track your food intake to identify patterns and areas for improvement.',
            emoji: '📝',
            color: Colors.blue,
            category: HealthTipCategory.nutrition,
          ),
        ];

      case BMICategory.moderatelyObese:
      case BMICategory.severelyObese:
      case BMICategory.verySeverelyObese:
        return [
          HealthTip(
            title: 'Medical Support',
            description:
                'Consult with healthcare professionals for a comprehensive weight management plan.',
            emoji: '👨‍⚕️',
            color: Colors.red,
            category: HealthTipCategory.medical,
          ),
          HealthTip(
            title: 'Start Gradually',
            description:
                'Begin with low-impact activities like walking and gradually increase intensity.',
            emoji: '🚶‍♀️',
            color: Colors.green,
            category: HealthTipCategory.exercise,
          ),
          HealthTip(
            title: 'Professional Guidance',
            description:
                'Work with a registered dietitian to develop a sustainable eating plan.',
            emoji: '👩‍⚕️',
            color: Colors.purple,
            category: HealthTipCategory.medical,
          ),
          HealthTip(
            title: 'Support System',
            description:
                'Build a support network of family, friends, or support groups.',
            emoji: '🤝',
            color: Colors.pink,
            category: HealthTipCategory.lifestyle,
          ),
        ];
    }
  }

  // Additional utility methods for future enhancements
  double getIdealWeightForHeight(double height) {
    final heightM = height / 100;
    return 22.0 * heightM * heightM; // BMI of 22 is middle of healthy range
  }

  double getBMIFromWeightAndHeight(double weight, double height) {
    final heightM = height / 100;
    return weight / (heightM * heightM);
  }

  List<double> getHealthyWeightRangeForHeight(double height) {
    final heightM = height / 100;
    final minWeight = 18.5 * heightM * heightM;
    final maxWeight = 24.9 * heightM * heightM;
    return [minWeight, maxWeight];
  }
}
