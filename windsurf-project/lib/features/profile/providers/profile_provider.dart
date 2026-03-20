import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> updateProfileImage(BuildContext context, UserModel user, String imageUrl) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final updatedUser = user.copyWith(profileImageUrl: imageUrl);
      
      await authProvider.updateUserProfile(updatedUser);
    } catch (e) {
      _errorMessage = 'Error updating profile image: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(BuildContext context, UserModel user) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
