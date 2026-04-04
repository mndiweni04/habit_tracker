import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/habit_provider.dart';

class DetailScreen extends StatelessWidget {
  final Habit habit;
  const DetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(habit.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Goal: ${habit.goal}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Text("Performance History", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [FlSpot(0, 1), FlSpot(1, 1), FlSpot(2, 0), FlSpot(3, 1), FlSpot(4, 1)],
                      isCurved: true,
                      color: habit.color,
                      barWidth: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}