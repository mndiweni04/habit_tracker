import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reminders")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTimeTile("Morning", "08:00 AM"),
          _buildTimeTile("Afternoon", "01:00 PM"),
          _buildTimeTile("Evening", "08:00 PM"),
        ],
      ),
    );
  }

  Widget _buildTimeTile(String title, String time) {
    return ListTile(
      title: Text(title),
      subtitle: Text("Reminder set for $time"),
      trailing: const Icon(Icons.access_time),
      onTap: () {},
    );
  }
}