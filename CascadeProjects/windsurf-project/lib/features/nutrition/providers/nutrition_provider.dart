import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../models/nutrition_model.dart';

class NutritionProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  NutritionEntry? _todayNutrition;
  List<WaterIntake> _todayWaterIntake = [];
  bool _isLoading = false;
  String? _errorMessage;

  NutritionEntry? get todayNutrition => _todayNutrition;
  List<WaterIntake> get todayWaterIntake => _todayWaterIntake;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTodayNutrition(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _todayNutrition = await _firestoreService.getTodayNutrition(userId);
      if (_todayNutrition == null) {
        _todayNutrition = NutritionEntry(
          userId: userId,
          date: DateTime.now(),
          calories: 0,
          protein: 0,
          water: 0,
          meals: [],
        );
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading nutrition data: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTodayWaterIntake(String userId) async {
    try {
      _todayWaterIntake = [];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading water intake: $e';
      notifyListeners();
    }
  }

  Future<void> addMeal(String userId, Meal meal) async {
    try {
      if (_todayNutrition == null) {
        _todayNutrition = NutritionEntry(
          userId: userId,
          date: DateTime.now(),
          calories: 0,
          protein: 0,
          water: 0,
          meals: [],
        );
      }

      final updatedMeals = List<Meal>.from(_todayNutrition!.meals)..add(meal);
      final updatedCalories = _todayNutrition!.calories + meal.calories;
      final updatedProtein = _todayNutrition!.protein + meal.protein;

      final updatedEntry = _todayNutrition!.copyWith(
        meals: updatedMeals,
        calories: updatedCalories,
        protein: updatedProtein,
      );

      if (_todayNutrition!.id == null) {
        await _firestoreService.createNutritionEntry(updatedEntry);
      } else {
        await _firestoreService.updateNutritionEntry(updatedEntry);
      }

      _todayNutrition = updatedEntry;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error adding meal: $e';
      notifyListeners();
    }
  }

  Future<void> addWaterIntake(String userId, double amount) async {
    try {
      final waterIntake = WaterIntake(
        userId: userId,
        date: DateTime.now(),
        amount: amount,
        timestamp: DateTime.now(),
      );

      await _firestoreService.addWaterIntake(waterIntake);
      
      _todayWaterIntake.add(waterIntake);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error adding water intake: $e';
      notifyListeners();
    }
  }

  double getTodayWaterTotal() {
    return _todayWaterIntake
        .map((water) => water.amount)
        .fold(0.0, (a, b) => a + b);
  }

  Future<void> deleteMeal(String userId, Meal meal) async {
    try {
      if (_todayNutrition != null) {
        final updatedMeals = _todayNutrition!.meals
            .where((m) => m.timestamp != meal.timestamp)
            .toList();
        
        final updatedCalories = _todayNutrition!.calories - meal.calories;
        final updatedProtein = _todayNutrition!.protein - meal.protein;

        final updatedEntry = _todayNutrition!.copyWith(
          meals: updatedMeals,
          calories: updatedCalories,
          protein: updatedProtein,
        );

        await _firestoreService.updateNutritionEntry(updatedEntry);
        _todayNutrition = updatedEntry;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error deleting meal: $e';
      notifyListeners();
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
