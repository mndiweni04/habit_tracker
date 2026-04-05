import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _darkModeKey = 'darkMode';
  static const String _userNameKey = 'userName';
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _habitsDataKey = 'habitsData';

  Future<void> setLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, status);
  }

  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> saveUserCredentials(String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, username);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
  }

  Future<Map<String, String?>> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(_userNameKey),
      'email': prefs.getString(_emailKey),
      'password': prefs.getString(_passwordKey),
    };
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? 'User';
  }

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDark);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> saveHabits(String habitsJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_habitsDataKey, habitsJson);
  }

  Future<String?> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_habitsDataKey);
  }
}