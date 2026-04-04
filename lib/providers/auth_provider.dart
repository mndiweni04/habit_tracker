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

  Future<void> login(String email, String password) async {
    _isAuthenticated = true;
    _userName = await _storage.getUserName();
    await _storage.setLoginStatus(true);
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _isAuthenticated = true;
    _userName = name;
    await _storage.setUserName(name);
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