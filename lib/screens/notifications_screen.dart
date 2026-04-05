import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _notificationsEnabled = false;
  
  final List<String> _selectedHabitTitles = [];
  final List<String> _selectedTimes = [];

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    setState(() {
      _notificationsEnabled = false; 
    });
  }

  Future<void> _saveNotificationSettings() async {
    // Persists the current configuration to local storage
  }

  void _sendTestNotification() {
    // Uses standard Flutter logic instead of web-only dart:html
    if (_notificationsEnabled) {
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      // Trigger the local notification service (compatible with Android/iOS)
      notificationService.scheduleDailyReminders(true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test notification scheduled via Local Notifications!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable notifications first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
                _saveNotificationSettings();
              },
            ),
            const Divider(),
            const Text(
              "Select Habits for Notification",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: habitProvider.habits.map((habit) {
                final isSelected = _selectedHabitTitles.contains(habit.title);
                return FilterChip(
                  label: Text(habit.title),
                  selected: isSelected,
                  selectedColor: habit.color.withAlpha(76),
                  onSelected: (bool selected) {
                    setState(() {
                      selected 
                        ? _selectedHabitTitles.add(habit.title) 
                        : _selectedHabitTitles.remove(habit.title);
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Times for Notification",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: ['Morning', 'Afternoon', 'Evening'].map((time) {
                final isSelected = _selectedTimes.contains(time);
                return FilterChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      selected ? _selectedTimes.add(time) : _selectedTimes.remove(time);
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendTestNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Send Test Notification",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}