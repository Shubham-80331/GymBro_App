import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_bro_tracker/models/user_model.dart';
import 'package:gym_bro_tracker/models/workout_model.dart';
import 'package:gym_bro_tracker/models/nutrition_model.dart';
import 'package:gym_bro_tracker/models/progress_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data() as Map<String, dynamic>) : null);
  }

  // Workout operations
  Future<void> createWorkout(Workout workout) async {
    final docRef = _firestore.collection('workouts').doc();
    await docRef.set(workout.copyWith(id: docRef.id).toMap());
  }

  Future<void> updateWorkout(Workout workout) async {
    await _firestore.collection('workouts').doc(workout.id).update(workout.toMap());
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _firestore.collection('workouts').doc(workoutId).delete();
  }

  Stream<List<Workout>> getUserWorkouts(String userId) {
    return _firestore
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Workout.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<Workout>> getUserWorkoutsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    QuerySnapshot snapshot = await _firestore
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => Workout.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  // Exercise operations
  Future<void> createExercise(Exercise exercise) async {
    await _firestore.collection('exercises').doc(exercise.id).set(exercise.toMap());
  }

  Future<List<Exercise>> getAllExercises() async {
    QuerySnapshot snapshot = await _firestore.collection('exercises').get();
    return snapshot.docs.map((doc) => Exercise.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Exercise>> getExercisesByMuscleGroup(MuscleGroup muscleGroup) async {
    QuerySnapshot snapshot = await _firestore
        .collection('exercises')
        .where('muscleGroup', isEqualTo: muscleGroup.name)
        .get();
    return snapshot.docs.map((doc) => Exercise.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> createCustomExercise(Exercise exercise) async {
    await _firestore.collection('exercises').doc(exercise.id).set(exercise.toMap());
  }

  // Workout Plan operations
  Future<void> createWorkoutPlan(WorkoutPlan plan) async {
    await _firestore.collection('workoutPlans').doc(plan.id).set(plan.toMap());
  }

  Future<void> updateWorkoutPlan(WorkoutPlan plan) async {
    await _firestore.collection('workoutPlans').doc(plan.id).update(plan.toMap());
  }

  Future<WorkoutPlan?> getUserWorkoutPlan(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('workoutPlans')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return WorkoutPlan.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Nutrition operations
  Future<void> createNutritionEntry(NutritionEntry entry) async {
    final docRef = _firestore.collection('nutrition').doc();
    await docRef.set(entry.copyWith(id: docRef.id).toMap());
  }

  Future<void> updateNutritionEntry(NutritionEntry entry) async {
    await _firestore.collection('nutrition').doc(entry.id).update(entry.toMap());
  }

  Future<NutritionEntry?> getTodayNutrition(String userId) async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    QuerySnapshot snapshot = await _firestore
        .collection('nutrition')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThan: endOfDay.toIso8601String())
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return NutritionEntry.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  Stream<NutritionEntry?> getTodayNutritionStream(String userId) {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('nutrition')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThan: endOfDay.toIso8601String())
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty
            ? NutritionEntry.fromMap(snapshot.docs.first.data() as Map<String, dynamic>)
            : null);
  }

  Future<void> addWaterIntake(WaterIntake waterIntake) async {
    final docRef = _firestore.collection('waterIntake').doc();
    await docRef.set(waterIntake.copyWith(id: docRef.id).toMap());
  }

  Stream<List<WaterIntake>> getTodayWaterIntake(String userId) {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('waterIntake')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThan: endOfDay.toIso8601String())
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WaterIntake.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Progress operations
  Future<void> createProgressEntry(ProgressEntry entry) async {
    final docRef = _firestore.collection('progress').doc();
    await docRef.set(entry.copyWith(id: docRef.id).toMap());
  }

  Future<void> updateProgressEntry(ProgressEntry entry) async {
    await _firestore.collection('progress').doc(entry.id).update(entry.toMap());
  }

  Stream<List<ProgressEntry>> getUserProgress(String userId) {
    return _firestore
        .collection('progress')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProgressEntry.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<WeightEntry>> getUserWeightHistory(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('weightEntries')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => WeightEntry.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> createWeightEntry(WeightEntry entry) async {
    final docRef = _firestore.collection('weightEntries').doc();
    await docRef.set(entry.copyWith(id: docRef.id).toMap());
  }

  Future<void> createProgressPhoto(ProgressPhoto photo) async {
    final docRef = _firestore.collection('progressPhotos').doc();
    await docRef.set(photo.copyWith(id: docRef.id).toMap());
  }

  Stream<List<ProgressPhoto>> getUserProgressPhotos(String userId) {
    return _firestore
        .collection('progressPhotos')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProgressPhoto.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
