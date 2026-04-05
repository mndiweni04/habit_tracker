import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class DetailScreen extends StatelessWidget {
  final Habit habit;

  const DetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final currentIndex = habitProvider.habits.indexWhere((h) => h.title == habit.title && h.goal == habit.goal);
    final currentHabit = currentIndex != -1 ? habitProvider.habits[currentIndex] : habit;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(currentHabit.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: currentHabit.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: currentHabit.color, width: 2),
              ),
              child: Center(
                child: Icon(
                  currentHabit.isCompleted ? Icons.check_circle : Icons.pending_actions,
                  size: 80,
                  color: currentHabit.color,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              currentHabit.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: currentHabit.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                currentHabit.goal,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'About this Activity:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Maintain a steady rhythm and consistently track this activity to reach your goal of "${currentHabit.goal}". Tracking your progress daily helps build long-lasting patterns.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            if (currentIndex != -1)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    habitProvider.toggleHabit(currentIndex);
                  },
                  icon: Icon(currentHabit.isCompleted ? Icons.undo : Icons.check, color: Colors.white),
                  label: Text(currentHabit.isCompleted ? 'Mark as Pending' : 'Mark as Completed', style: const TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentHabit.isCompleted ? Colors.orange : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.blue),
                label: const Text('Back to List', style: TextStyle(color: Colors.blue, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}