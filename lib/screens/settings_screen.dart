import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: habitProvider.isDarkMode,
            onChanged: (val) => habitProvider.toggleDarkMode(val),
          ),
          ListTile(
            title: const Text("Test Notifications"),
            trailing: const Icon(Icons.notifications),
            onTap: () => notificationService.scheduleDailyReminders(true),
          ),
          ListTile(
            title: const Text("Logout"),
            trailing: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              authProvider.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}