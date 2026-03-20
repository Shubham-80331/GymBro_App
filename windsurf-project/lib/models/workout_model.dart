enum MuscleGroup { chest, back, legs, shoulders, arms, cardio, core }

class Exercise {
  final String id;
  final String name;
  final MuscleGroup muscleGroup;
  final String defaultSets;
  final String defaultReps;
  final String? instructions;
  final bool isCustom;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.defaultSets,
    required this.defaultReps,
    this.instructions,
    this.isCustom = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup.name,
      'defaultSets': defaultSets,
      'defaultReps': defaultReps,
      'instructions': instructions,
      'isCustom': isCustom,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      muscleGroup: MuscleGroup.values.firstWhere(
        (m) => m.name == map['muscleGroup'],
        orElse: () => MuscleGroup.chest,
      ),
      defaultSets: map['defaultSets'],
      defaultReps: map['defaultReps'],
      instructions: map['instructions'],
      isCustom: map['isCustom'] ?? false,
    );
  }
}

class ExerciseSet {
  final int reps;
  final double weight; // in kg

  const ExerciseSet({
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      reps: map['reps'],
      weight: (map['weight'] ?? 0).toDouble(),
    );
  }
}

class WorkoutExercise {
  final String exerciseId;
  final String exerciseName;
  final MuscleGroup muscleGroup;
  final List<ExerciseSet> sets;

  const WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'muscleGroup': muscleGroup.name,
      'sets': sets.map((set) => set.toMap()).toList(),
    };
  }

  factory WorkoutExercise.fromMap(Map<String, dynamic> map) {
    return WorkoutExercise(
      exerciseId: map['exerciseId'],
      exerciseName: map['exerciseName'],
      muscleGroup: MuscleGroup.values.firstWhere(
        (m) => m.name == map['muscleGroup'],
        orElse: () => MuscleGroup.chest,
      ),
      sets: (map['sets'] as List<dynamic>?)
          ?.map((set) => ExerciseSet.fromMap(set))
          .toList() ?? [],
    );
  }
}

class Workout {
  final String? id;
  final String userId;
  final DateTime date;
  final String name;
  final MuscleGroup primaryMuscleGroup;
  final List<WorkoutExercise> exercises;
  final Duration duration;
  final int totalVolume; // total weight lifted
  final DateTime? completedAt;

  const Workout({
    this.id,
    required this.userId,
    required this.date,
    required this.name,
    required this.primaryMuscleGroup,
    required this.exercises,
    required this.duration,
    required this.totalVolume,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'name': name,
      'primaryMuscleGroup': primaryMuscleGroup.name,
      'exercises': exercises.map((ex) => ex.toMap()).toList(),
      'duration': duration.inMinutes,
      'totalVolume': totalVolume,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      name: map['name'],
      primaryMuscleGroup: MuscleGroup.values.firstWhere(
        (m) => m.name == map['primaryMuscleGroup'],
        orElse: () => MuscleGroup.chest,
      ),
      exercises: (map['exercises'] as List<dynamic>?)
          ?.map((ex) => WorkoutExercise.fromMap(ex))
          .toList() ?? [],
      duration: Duration(minutes: map['duration'] ?? 0),
      totalVolume: map['totalVolume'] ?? 0,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
    );
  }

  Workout copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? name,
    MuscleGroup? primaryMuscleGroup,
    List<WorkoutExercise>? exercises,
    Duration? duration,
    int? totalVolume,
    DateTime? completedAt,
  }) {
    return Workout(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      name: name ?? this.name,
      primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
      exercises: exercises ?? this.exercises,
      duration: duration ?? this.duration,
      totalVolume: totalVolume ?? this.totalVolume,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class WorkoutPlan {
  final String id;
  final String userId;
  final Map<int, String> weeklyPlan; // dayOfWeek (1-7) -> workoutName

  const WorkoutPlan({
    required this.id,
    required this.userId,
    required this.weeklyPlan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'weeklyPlan': weeklyPlan,
    };
  }

  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      id: map['id'],
      userId: map['userId'],
      weeklyPlan: Map<int, String>.from(map['weeklyPlan'] ?? {}),
    );
  }

  WorkoutPlan copyWith({
    String? id,
    String? userId,
    Map<int, String>? weeklyPlan,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weeklyPlan: weeklyPlan ?? this.weeklyPlan,
    );
  }
}
