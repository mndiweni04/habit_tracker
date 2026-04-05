import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _darkModeKey = 'darkMode';
  static const String _userNameKey = 'userName';
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _habitsDataKey = 'habitsData';
  static const String _ageKey = 'age';
  static const String _countryKey = 'country';
  
  static const String _notificationsEnabledKey = 'notificationsEnabled';
  static const String _selectedHabitsKey = 'selectedHabits';
  static const String _selectedTimesKey = 'selectedTimes';

  // New method for Criterion 18 verification in VS Code
  Future<void> debugDump() async {
    final prefs = await SharedPreferences.getInstance();
    print("--- LOCAL STORAGE DUMP ---");
    for (String key in prefs.getKeys()) {
      print('$key: ${prefs.get(key)}');
    }
    print("--------------------------");
  }

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

  Future<void> setAge(double age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_ageKey, age);
  }

  Future<double> getAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_ageKey) ?? 25.0;
  }

  Future<void> setCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countryKey, country);
  }

  Future<String> getCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_countryKey) ?? 'Unknown';
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
  
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  Future<void> setSelectedHabits(List<String> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedHabitsKey, habits);
  }

  Future<List<String>> getSelectedHabits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_selectedHabitsKey) ?? [];
  }

  Future<void> setSelectedTimes(List<String> times) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedTimesKey, times);
  }

  Future<List<String>> getSelectedTimes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_selectedTimesKey) ?? [];
  }

  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}