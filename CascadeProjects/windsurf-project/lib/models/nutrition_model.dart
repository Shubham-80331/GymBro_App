class NutritionEntry {
  final String? id;
  final String userId;
  final DateTime date;
  final int calories;
  final double protein; // in grams
  final double water; // in liters
  final List<Meal> meals;

  const NutritionEntry({
    this.id,
    required this.userId,
    required this.date,
    required this.calories,
    required this.protein,
    required this.water,
    required this.meals,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'calories': calories,
      'protein': protein,
      'water': water,
      'meals': meals.map((meal) => meal.toMap()).toList(),
    };
  }

  factory NutritionEntry.fromMap(Map<String, dynamic> map) {
    return NutritionEntry(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      calories: map['calories'] ?? 0,
      protein: (map['protein'] ?? 0).toDouble(),
      water: (map['water'] ?? 0).toDouble(),
      meals: (map['meals'] as List<dynamic>?)
          ?.map((meal) => Meal.fromMap(meal))
          .toList() ?? [],
    );
  }

  NutritionEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? calories,
    double? protein,
    double? water,
    List<Meal>? meals,
  }) {
    return NutritionEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      water: water ?? this.water,
      meals: meals ?? this.meals,
    );
  }
}

class Meal {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime timestamp;

  const Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      name: map['name'],
      calories: map['calories'] ?? 0,
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class WaterIntake {
  final String? id;
  final String userId;
  final DateTime date;
  final double amount; // in liters
  final DateTime timestamp;

  const WaterIntake({
    this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WaterIntake.fromMap(Map<String, dynamic> map) {
    return WaterIntake(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      amount: (map['amount'] ?? 0).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
