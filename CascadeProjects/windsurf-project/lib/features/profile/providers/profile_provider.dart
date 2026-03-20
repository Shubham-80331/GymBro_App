import 'package:flutter/material.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> updateProfileImage(
      AuthProvider authProvider, UserModel user, String imageUrl) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final updatedUser = user.copyWith(profileImageUrl: imageUrl);
      await authProvider.updateUserProfile(updatedUser);
    } catch (e) {
      _errorMessage = 'Error updating profile image: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Overload that accepts only the user model (used by EditProfileScreen)
  Future<void> updateUserProfile(UserModel user) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _firestoreService.updateUser(user);
    } catch (e) {
      _errorMessage = 'Error updating profile: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Overload that accepts AuthProvider (used internally)
  Future<void> updateUserProfileWithAuth(
      AuthProvider authProvider, UserModel user) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await authProvider.updateUserProfile(user);
    } catch (e) {
      _errorMessage = 'Error updating profile: $e';
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
