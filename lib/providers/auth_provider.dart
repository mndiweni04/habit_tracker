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
    
    if ((creds['email'] == email || creds['username'] == email) && creds['password'] == password) {
      _isAuthenticated = true;
      _userName = await _storage.getUserName();
      await _storage.setLoginStatus(true);
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future<void> loginHardcoded() async {
    _isAuthenticated = true;
    _userName = 'Test User';
    await _storage.saveUserCredentials('testuser', 'testuser@example.com', 'password123');
    await _storage.setUserName('Test User');
    await _storage.setAge(25);
    await _storage.setCountry('United States');
    await _storage.setLoginStatus(true);
    notifyListeners();
  }

  Future<void> register(String username, String email, String password) async {
    _isAuthenticated = true;
    _userName = username;
    await _storage.saveUserCredentials(username, email, password);
    await _storage.setUserName(username);
    await _storage.setLoginStatus(true);
    notifyListeners();
  }
  
  Future<void> registerFullProfile({
    required String name,
    required String username,
    required String email,
    required String password,
    required double age,
    required String country,
  }) async {
    _isAuthenticated = true;
    _userName = name;
    
    await _storage.saveUserCredentials(username, email, password);
    await _storage.setUserName(name);
    await _storage.setAge(age);
    await _storage.setCountry(country);
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