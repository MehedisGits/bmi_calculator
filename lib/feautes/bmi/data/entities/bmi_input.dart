enum Gender { male, female }

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
  BMIInput copyWith({double? height, double? weight, int? age, Gender? gender}) {
    return BMIInput(
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
    );
  }
}