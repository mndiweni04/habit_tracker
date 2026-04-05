import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  bool _isAuthenticated = false;
  String _userName = '';

  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isAuthenticated = await _storage.getLoginStatus();
    if (_isAuthenticated) {
      _userName = await _storage.getUserName();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final creds = await _storage.getUserCredentials();
    
    if (creds['email'] == email && creds['password'] == password) {
      _isAuthenticated = true;
      _userName = creds['username'] ?? 'User';
      await _storage.setLoginStatus(true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> register(String username, String email, String password) async {
    _isAuthenticated = true;
    _userName = username;
    await _storage.saveUserCredentials(username, email, password);
    await _storage.setLoginStatus(true);
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userName = '';
    await _storage.setLoginStatus(false);
    notifyListeners();
  }
}