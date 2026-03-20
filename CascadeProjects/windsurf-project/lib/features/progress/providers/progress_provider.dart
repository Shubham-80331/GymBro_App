import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../models/progress_model.dart';

class ProgressProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ProgressEntry> _progressEntries = [];
  List<WeightEntry> _weightHistory = [];
  List<ProgressPhoto> _progressPhotos = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<ProgressEntry> get progressEntries => _progressEntries;
  List<WeightEntry> get weightHistory => _weightHistory;
  List<ProgressPhoto> get progressPhotos => _progressPhotos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProgressData(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _listenProgressEntries(userId);
      await _loadWeightHistory(userId);
      await _loadProgressPhotos(userId);
    } catch (e) {
      _errorMessage = 'Error loading progress data: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _listenProgressEntries(String userId) {
    _firestoreService.getUserProgress(userId).listen((entries) {
      _progressEntries = entries;
      notifyListeners();
    });
  }

  Future<void> _loadWeightHistory(String userId) async {
    _weightHistory = await _firestoreService.getUserWeightHistory(userId);
    notifyListeners();
  }

  Future<void> _loadProgressPhotos(String userId) async {
    _progressPhotos = [];
    notifyListeners();
  }

  Future<void> addWeightEntry(WeightEntry entry) async {
    try {
      await _firestoreService.createWeightEntry(entry);
      await _loadWeightHistory(entry.userId);
    } catch (e) {
      _errorMessage = 'Error adding weight entry: $e';
      notifyListeners();
    }
  }

  Future<void> addProgressEntry(ProgressEntry entry) async {
    try {
      await _firestoreService.createProgressEntry(entry);
    } catch (e) {
      _errorMessage = 'Error adding progress entry: $e';
      notifyListeners();
    }
  }

  double getWeightChange() {
    if (_weightHistory.length < 2) return 0.0;

    final latest = _weightHistory.first.weight;
    final previous = _weightHistory[1].weight;

    return latest - previous;
  }

  double getTotalWeightChange() {
    if (_weightHistory.isEmpty) return 0.0;

    final latest = _weightHistory.first.weight;
    final oldest = _weightHistory.last.weight;

    return latest - oldest;
  }

  List<WeightEntry> getWeightChartData() {
    return _weightHistory.take(30).toList().reversed.toList();
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
