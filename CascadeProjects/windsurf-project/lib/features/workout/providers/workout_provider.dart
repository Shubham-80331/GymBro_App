import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../models/workout_model.dart';

class WorkoutProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Exercise> _exercises = [];
  List<Workout> _workouts = [];
  WorkoutPlan? _workoutPlan;
  bool _isLoading = false;
  String? _errorMessage;

  List<Exercise> get exercises => _exercises;
  List<Workout> get workouts => _workouts;
  WorkoutPlan? get workoutPlan => _workoutPlan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadExercises() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _exercises = await _firestoreService.getAllExercises();
      if (_exercises.isEmpty) {
        await _createDefaultExercises();
        _exercises = await _firestoreService.getAllExercises();
      }
    } catch (e) {
      _errorMessage = 'Error loading exercises: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUserWorkouts(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _workouts = await _firestoreService.getUserWorkoutsByDateRange(
        userId,
        DateTime.now().subtract(const Duration(days: 30)),
        DateTime.now(),
      );
    } catch (e) {
      _errorMessage = 'Error loading workouts: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadWorkoutPlan(String userId) async {
    try {
      _workoutPlan = await _firestoreService.getUserWorkoutPlan(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading workout plan: $e';
      notifyListeners();
    }
  }

  Future<void> createWorkout(Workout workout) async {
    try {
      await _firestoreService.createWorkout(workout);
      await loadUserWorkouts(workout.userId);
    } catch (e) {
      _errorMessage = 'Error creating workout: $e';
      notifyListeners();
    }
  }

  Future<void> updateWorkoutPlan(WorkoutPlan plan) async {
    try {
      await _firestoreService.updateWorkoutPlan(plan);
      _workoutPlan = plan;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error updating workout plan: $e';
      notifyListeners();
    }
  }

  Future<void> createCustomExercise(Exercise exercise) async {
    try {
      await _firestoreService.createCustomExercise(exercise);
      await loadExercises();
    } catch (e) {
      _errorMessage = 'Error creating custom exercise: $e';
      notifyListeners();
    }
  }

  List<Exercise> getExercisesByMuscleGroup(MuscleGroup muscleGroup) {
    return _exercises
        .where((exercise) => exercise.muscleGroup == muscleGroup)
        .toList();
  }

  Future<void> _createDefaultExercises() async {
    final defaultExercises = [
      // Chest
      Exercise(
        id: 'chest_press',
        name: 'Chest Press',
        muscleGroup: MuscleGroup.chest,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Lie on bench, press barbell up from chest',
      ),
      Exercise(
        id: 'incline_chest_press',
        name: 'Incline Chest Press',
        muscleGroup: MuscleGroup.chest,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Incline bench press targeting upper chest',
      ),
      Exercise(
        id: 'decline_barbell_press',
        name: 'Decline Barbell Press',
        muscleGroup: MuscleGroup.chest,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Decline bench press targeting lower chest',
      ),
      Exercise(
        id: 'chest_fly',
        name: 'Chest Fly',
        muscleGroup: MuscleGroup.chest,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Fly motion targeting chest muscles',
      ),

      // Triceps
      Exercise(
        id: 'overhead_tricep_extension',
        name: 'Overhead Tricep Extension',
        muscleGroup: MuscleGroup.arms,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Extend arms overhead targeting triceps',
      ),
      Exercise(
        id: 'rope_tricep_extension',
        name: 'Rope Tricep Extension',
        muscleGroup: MuscleGroup.arms,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Cable rope tricep pushdown',
      ),
      Exercise(
        id: 'tricep_dips',
        name: 'Tricep Dips',
        muscleGroup: MuscleGroup.arms,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Bodyweight or weighted dips',
      ),

      // Back
      Exercise(
        id: 'lat_pull_down',
        name: 'Lat Pull Down',
        muscleGroup: MuscleGroup.back,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Pull lat bar down to upper chest',
      ),
      Exercise(
        id: 'bent_over_barbell_row',
        name: 'Bent Over Barbell Row',
        muscleGroup: MuscleGroup.back,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Row barbell to lower chest',
      ),
      Exercise(
        id: 'seated_row',
        name: 'Seated Row',
        muscleGroup: MuscleGroup.back,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Seated cable row targeting back muscles',
      ),
      Exercise(
        id: 'back_extension',
        name: 'Back Extension',
        muscleGroup: MuscleGroup.back,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Hyperextensions for lower back',
      ),

      // Biceps
      Exercise(
        id: 'alternating_dumbbell_curl',
        name: 'Alternating Dumbbell Curl',
        muscleGroup: MuscleGroup.arms,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Alternate curling dumbbells',
      ),
      Exercise(
        id: 'preacher_curl',
        name: 'Preacher Curl',
        muscleGroup: MuscleGroup.arms,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Curls on preacher bench',
      ),
      Exercise(
        id: 'alternating_hammer_curl',
        name: 'Alternating Hammer Curl',
        muscleGroup: MuscleGroup.arms,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Hammer curls with dumbbells',
      ),

      // Shoulders
      Exercise(
        id: 'shoulder_press',
        name: 'Shoulder Press',
        muscleGroup: MuscleGroup.shoulders,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Overhead press targeting shoulders',
      ),
      Exercise(
        id: 'lateral_raises',
        name: 'Lateral Raises',
        muscleGroup: MuscleGroup.shoulders,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Side lateral raises',
      ),
      Exercise(
        id: 'front_raises',
        name: 'Front Raises',
        muscleGroup: MuscleGroup.shoulders,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Front raises targeting front delts',
      ),
      Exercise(
        id: 'reverse_fly',
        name: 'Reverse Fly',
        muscleGroup: MuscleGroup.shoulders,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Reverse fly for rear delts',
      ),
      Exercise(
        id: 'cable_face_pull',
        name: 'Cable Face Pull',
        muscleGroup: MuscleGroup.shoulders,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Face pulls for rear delts and upper back',
      ),
      Exercise(
        id: 'dumbbell_shrugs',
        name: 'Dumbbell Shrugs',
        muscleGroup: MuscleGroup.shoulders,
        defaultSets: '3',
        defaultReps: '12-15',
        instructions: 'Shrugs targeting traps',
      ),
    ];

    for (final exercise in defaultExercises) {
      await _firestoreService.createExercise(exercise);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
