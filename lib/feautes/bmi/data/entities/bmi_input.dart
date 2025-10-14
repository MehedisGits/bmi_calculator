import 'package:flutter/material.dart';

enum Gender { 
  male('Male', '👨', Colors.blue),
  female('Female', '👩', Colors.pink);

  const Gender(this.label, this.icon, this.color);

  final String label;
  final String icon;
  final Color color;
 }

class BMIInput {
  final double height;
  final double weight;
  final int age;
  final Gender gender;

  const BMIInput({
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
  });
  BMIInput copyWith({
    double? height,
    double? weight,
    int? age,
    Gender? gender,
  }) {
    return BMIInput(
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender.name,
    };
  }

  factory BMIInput.fromJson(Map<String, dynamic> json) {
    return BMIInput(
      height: json['height']?.toDouble() ?? 170.0,
      weight: json['weight']?.toDouble() ?? 70.0,
      age: json['age']?.toInt() ?? 25,
      gender: Gender.values.firstWhere(
        (g) => g.name == json['gender'],
        orElse: () => Gender.male,
      ),
    );
  }
}
