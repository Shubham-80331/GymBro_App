import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../models/workout_model.dart';
import '../../../models/nutrition_model.dart';

class HomeProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  WorkoutPlan? _workoutPlan;
  List<Workout> _recentWorkouts = [];
  NutritionEntry? _todayNutrition;
  List<WaterIntake> _todayWaterIntake = [];
  bool _isLoading = false;
  String? _errorMessage;

  WorkoutPlan? get workoutPlan => _workoutPlan;
  List<Workout> get recentWorkouts => _recentWorkouts;
  NutritionEntry? get todayNutrition => _todayNutrition;
  List<WaterIntake> get todayWaterIntake => _todayWaterIntake;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHomeData(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await Future.wait([
        _loadWorkoutPlan(userId),
        _loadRecentWorkouts(userId),
        _loadTodayNutrition(userId),
        _loadTodayWaterIntake(userId),
      ]);
    } catch (e) {
      _errorMessage = 'Error loading home data: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadWorkoutPlan(String userId) async {
    _workoutPlan = await _firestoreService.getUserWorkoutPlan(userId);
    notifyListeners();
  }

  Future<void> _loadRecentWorkouts(String userId) async {
    DateTime now = DateTime.now();
    DateTime oneWeekAgo = now.subtract(const Duration(days: 7));
    
    _recentWorkouts = await _firestoreService.getUserWorkoutsByDateRange(
      userId,
      oneWeekAgo,
      now,
    );
    notifyListeners();
  }

  Future<void> _loadTodayNutrition(String userId) async {
    _todayNutrition = await _firestoreService.getTodayNutrition(userId);
    notifyListeners();
  }

  Future<void> _loadTodayWaterIntake(String userId) async {
    _todayWaterIntake = [];
    notifyListeners();
  }

  String? getTodayWorkoutName() {
    if (_workoutPlan == null) return null;
    
    final today = DateTime.now();
    final dayOfWeek = today.weekday; // 1 = Monday, 7 = Sunday
    
    return _workoutPlan!.weeklyPlan[dayOfWeek];
  }

  double getTodayCalorieProgress() {
    if (_todayNutrition == null) return 0.0;
    return _todayNutrition!.calories.toDouble();
  }

  double getTodayProteinProgress() {
    if (_todayNutrition == null) return 0.0;
    return _todayNutrition!.protein;
  }

  double getTodayWaterProgress() {
    if (_todayWaterIntake.isEmpty) return 0.0;
    return _todayWaterIntake
        .map((water) => water.amount)
        .reduce((a, b) => a + b);
  }

  int getWorkoutStreak() {
    if (_recentWorkouts.isEmpty) return 0;
    
    // Simple streak calculation - consecutive days with workouts
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final checkDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day - i,
      );
      
      final hasWorkout = _recentWorkouts.any((workout) {
        final workoutDate = DateTime(
          workout.date.year,
          workout.date.month,
          workout.date.day,
        );
        return workoutDate.isAtSameMomentAs(checkDate);
      });
      
      if (hasWorkout) {
        streak++;
      } else if (i > 0) {
        break; // Break if streak is broken (allow today to be missed)
      }
    }
    
    return streak;
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
