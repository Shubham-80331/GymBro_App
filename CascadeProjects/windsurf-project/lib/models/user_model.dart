enum Gender { male, female, other }

enum ActivityLevel { sedentary, lightly, moderately, very }

enum FitnessGoal { cut, maintain, bulk }

class UserModel {
  final String? id;
  final String name;
  final String email;
  final int age;
  final Gender gender;
  final double height; // in cm
  final double weight; // in kg
  final ActivityLevel activityLevel;
  final FitnessGoal fitnessGoal;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? lastWorkoutDate;
  final int workoutStreak;
  final int waterStreak;
  final int proteinStreak;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.fitnessGoal,
    this.profileImageUrl,
    required this.createdAt,
    this.lastWorkoutDate,
    this.workoutStreak = 0,
    this.waterStreak = 0,
    this.proteinStreak = 0,
  });

  double get bmi {
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  String get goalSuggestion {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'Lean Bulk';
    if (bmiValue < 25) return 'Maintain';
    if (bmiValue < 30) return 'Cut';
    return 'Cut';
  }

  int get maintenanceCalories {
    int bmr;
    if (gender == Gender.male) {
      bmr = (88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)).round();
    } else {
      bmr = (447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)).round();
    }

    double activityMultiplier;
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        activityMultiplier = 1.2;
        break;
      case ActivityLevel.lightly:
        activityMultiplier = 1.375;
        break;
      case ActivityLevel.moderately:
        activityMultiplier = 1.55;
        break;
      case ActivityLevel.very:
        activityMultiplier = 1.725;
        break;
    }

    return (bmr * activityMultiplier).round();
  }

  int get calorieTarget {
    final maintenance = maintenanceCalories;
    switch (fitnessGoal) {
      case FitnessGoal.cut:
        return maintenance - 400; // Average of -300 to -500
      case FitnessGoal.maintain:
        return maintenance;
      case FitnessGoal.bulk:
        return maintenance + 400; // Average of +300 to +500
    }
  }

  double get proteinTarget {
    switch (fitnessGoal) {
      case FitnessGoal.cut:
        return weight * 1.8;
      case FitnessGoal.maintain:
        return weight * 1.6;
      case FitnessGoal.bulk:
        return weight * 2.0;
    }
  }

  double get waterTarget {
    return (weight * 35) / 1000; // Convert ml to liters
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender.name,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel.name,
      'fitnessGoal': fitnessGoal.name,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastWorkoutDate': lastWorkoutDate?.toIso8601String(),
      'workoutStreak': workoutStreak,
      'waterStreak': waterStreak,
      'proteinStreak': proteinStreak,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
      gender: Gender.values.firstWhere(
        (g) => g.name == map['gender'],
        orElse: () => Gender.male,
      ),
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      activityLevel: ActivityLevel.values.firstWhere(
        (a) => a.name == map['activityLevel'],
        orElse: () => ActivityLevel.moderately,
      ),
      fitnessGoal: FitnessGoal.values.firstWhere(
        (f) => f.name == map['fitnessGoal'],
        orElse: () => FitnessGoal.maintain,
      ),
      profileImageUrl: map['profileImageUrl'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastWorkoutDate: map['lastWorkoutDate'] != null
          ? DateTime.parse(map['lastWorkoutDate'])
          : null,
      workoutStreak: map['workoutStreak'] ?? 0,
      waterStreak: map['waterStreak'] ?? 0,
      proteinStreak: map['proteinStreak'] ?? 0,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    Gender? gender,
    double? height,
    double? weight,
    ActivityLevel? activityLevel,
    FitnessGoal? fitnessGoal,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastWorkoutDate,
    int? workoutStreak,
    int? waterStreak,
    int? proteinStreak,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      workoutStreak: workoutStreak ?? this.workoutStreak,
      waterStreak: waterStreak ?? this.waterStreak,
      proteinStreak: proteinStreak ?? this.proteinStreak,
    );
  }
}
