import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final totalHabits = habitProvider.habits.length;
    final completedHabits = habitProvider.habits.where((h) => h.isCompleted).length;
    final pendingHabits = totalHabits - completedHabits;
    final progress = totalHabits == 0 ? 0.0 : completedHabits / totalHabits;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Overall Progress",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              minHeight: 25,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Text(
              "${(progress * 100).toStringAsFixed(1)}% Completed",
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildStatCard("Total Habits Tracked", totalHabits.toString(), Colors.blue),
            const SizedBox(height: 15),
            _buildStatCard("Completed Today", completedHabits.toString(), Colors.green),
            const SizedBox(height: 15),
            _buildStatCard("Pending", pendingHabits.toString(), Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.shade200, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color.shade700)),
        ],
      ),
    );
  }
}