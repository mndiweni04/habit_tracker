import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Habit {
  final String title;
  final String goal;
  bool isCompleted;
  final Color color;

  Habit({required this.title, required this.goal, this.isCompleted = false, this.color = Colors.blue});

  Map<String, dynamic> toJson() => {
    'title': title,
    'goal': goal,
    'isCompleted': isCompleted,
    'colorValue': color.value,
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    title: json['title'],
    goal: json['goal'],
    isCompleted: json['isCompleted'],
    color: Color(json['colorValue']),
  );
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
        Habit(title: "Drink Water", goal: "2L Goal", color: Colors.blue),
        Habit(title: "Morning Meds", goal: "1 Dose", color: Colors.green),
      ];
    }
    notifyListeners();
  }

  Future<void> _saveHabits() async {
    final encoded = jsonEncode(_habits.map((h) => h.toJson()).toList());
    await _storage.saveHabits(encoded);
  }
}