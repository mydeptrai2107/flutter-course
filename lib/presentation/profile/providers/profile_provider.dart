import 'package:app/models/user_model.dart';
import 'package:app/repository/user_repository.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final userData = await UserRepository.getCurrentUserProfile();
      _user = userData;
    } catch (e) {
      _errorMessage = 'Lỗi khi lấy thông tin: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await UserRepository.updateProfile(
        name: name,
        phone: phone,
      );

      if (success && _user != null) {
        _user = _user!.copyWith(name: name, phone: phone);
        _errorMessage = '';
      } else {
        _errorMessage = 'Cập nhật thất bại';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Lỗi: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await fetchUserProfile();
  }

  // Logout
  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await UserRepository.logout();
      if (success) {
        _user = null;
      }
      return success;
    } catch (e) {
      _errorMessage = 'Lỗi khi đăng xuất: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await UserRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        _errorMessage = '';
      } else {
        _errorMessage = 'Mật khẩu hiện tại không đúng';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Lỗi: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
