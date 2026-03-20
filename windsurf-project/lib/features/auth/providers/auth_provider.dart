import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => true; // Always true for "open and run"

  AuthProvider() {
    _user = _authService.currentUser;
    if (_user != null) {
      _loadUserData();
    } else {
      // Default guest user for "open and run" mode
      _userModel = _getGuestUser();
    }
    
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userModel = _getGuestUser();
      }
      notifyListeners();
    });
  }

  UserModel _getGuestUser() {
    return UserModel(
      id: 'guest_user',
      name: 'Gym Bro',
      email: 'guest@gymbro.com',
      age: 25,
      gender: Gender.male,
      height: 175,
      weight: 75,
      activityLevel: ActivityLevel.moderately,
      fitnessGoal: FitnessGoal.maintain,
      createdAt: DateTime.now(),
      workoutStreak: 3,
      waterStreak: 5,
      proteinStreak: 2,
    );
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;
    
    try {
      final data = await _firestoreService.getUser(_user!.uid);
      if (data != null) {
        _userModel = data;
      } else {
        _userModel = _getGuestUser();
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading user data: $e';
      _userModel = _getGuestUser();
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      UserCredential? result = await _authService.signInWithEmail(email, password);
      if (result != null) {
        await _loadUserData();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      UserCredential? result = await _authService.signUpWithEmail(email, password);
      return result != null;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      UserCredential? result = await _authService.signInWithGoogle();
      if (result != null) {
        await _loadUserData();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _userModel = _getGuestUser();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createUserProfile(UserModel user) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _firestoreService.createUser(user);
      _userModel = user;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (_user != null) {
        await _firestoreService.updateUser(user);
      }
      _userModel = user;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
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
