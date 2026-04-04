import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("HabitLoop"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back, ${authProvider.userName}!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildProgressCard(habitProvider.progress),
            const SizedBox(height: 20),
            const Text("Your Habits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: habitProvider.habits.length,
                itemBuilder: (context, index) {
                  final habit = habitProvider.habits[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: habit.color),
                    title: Text(habit.title),
                    subtitle: Text(habit.goal),
                    trailing: Checkbox(
                      value: habit.isCompleted,
                      onChanged: (_) => habitProvider.toggleHabit(index),
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(habit: habit))),
                  );
                },
              ),
            ),
            _buildQuoteSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(double progress) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircularProgressIndicator(value: progress, strokeWidth: 8),
            const SizedBox(width: 20),
            Text("${(progress * 100).toInt()}% Done", style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteSection() {
    return FutureBuilder(
      future: ApiService().fetchDailyQuote(),
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(snapshot.data ?? "Loading motivation...", style: const TextStyle(fontStyle: FontStyle.italic)),
        );
      },
    );
  }
}