import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Habit {
  final String title;
  final String goal;
  bool isCompleted;
  final String colorHex;

  Habit({
    required this.title,
    required this.goal,
    this.isCompleted = false,
    required this.colorHex,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'goal': goal,
    'isCompleted': isCompleted,
    'colorHex': colorHex,
  };

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      // Use null-coalescing to provide defaults if keys are missing or null
      title: json['title'] ?? 'New Habit',
      goal: json['goal'] ?? 'Daily Goal',
      isCompleted: json['isCompleted'] ?? false,
      colorHex: json['colorHex'] ?? 'FF2196F3', // Default to Blue
    );
  }

  Color get color => Color(int.parse(colorHex, radix: 16));
}
class HabitProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  bool _isDarkMode = false;
  List<Habit> _habits = [];

  bool get isDarkMode => _isDarkMode;
  List<Habit> get habits => _habits;
  double get progress => _habits.isEmpty ? 0 : _habits.where((h) => h.isCompleted).length / _habits.length;

  HabitProvider() {
    _loadData();
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    _saveHabits();
    notifyListeners();
  }

  void deleteHabit(int index) {
    _habits.removeAt(index);
    _saveHabits();
    notifyListeners();
  }

  void toggleHabit(int index) {
    _habits[index].isCompleted = !_habits[index].isCompleted;
    _saveHabits();
    notifyListeners();
  }

  void toggleDarkMode(bool val) {
    _isDarkMode = val;
    _storage.setDarkMode(val);
    notifyListeners();
  }

  Future<void> _loadData() async {
    _isDarkMode = await _storage.getDarkMode();
    final habitsJson = await _storage.getHabits();
    if (habitsJson != null) {
      final List<dynamic> decoded = jsonDecode(habitsJson);
      _habits = decoded.map((h) => Habit.fromJson(h)).toList();
    } else {
      _habits = [
        Habit(title: "Drink Water", goal: "2L Goal", colorHex: "FF2196F3"),
        Habit(title: "Morning Meds", goal: "1 Dose", colorHex: "FF4CAF50"),
      ];
    }
    notifyListeners();
  }

  Future<void> _saveHabits() async {
    final encoded = jsonEncode(_habits.map((h) => h.toJson()).toList());
    await _storage.saveHabits(encoded);
  }
}