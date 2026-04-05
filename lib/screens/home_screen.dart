import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../providers/auth_provider.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final todoHabits = habitProvider.habits.where((h) => !h.isCompleted).toList();
    final doneHabits = habitProvider.habits.where((h) => h.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Loading..."), 
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      drawer: _buildDrawer(context, authProvider),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Hello ${authProvider.userName}!", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("To Do ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.edit_document, size: 20),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: todoHabits.isEmpty
                  ? const Center(child: Text("Use the + button to create some habits!", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: todoHabits.length,
                      itemBuilder: (context, index) {
                        final habit = todoHabits[index];
                        final originalIndex = habitProvider.habits.indexOf(habit);
                        return Dismissible(
                          key: Key(habit.title + originalIndex.toString()),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            color: Colors.blue.shade400,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20.0),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            habitProvider.toggleHabit(originalIndex);
                          },
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(backgroundColor: habit.color),
                              title: Text(habit.title),
                              subtitle: Text(habit.goal),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(habit: habit))),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            const Divider(thickness: 1, height: 30),
            
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Done ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.check_box, size: 20),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: doneHabits.isEmpty
                  ? const Center(child: Text("Swipe right on an activity to mark as done", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: doneHabits.length,
                      itemBuilder: (context, index) {
                        final habit = doneHabits[index];
                        final originalIndex = habitProvider.habits.indexOf(habit);
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: habit.color.withOpacity(0.5)),
                            title: Text(habit.title, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                            subtitle: Text(habit.goal),
                            trailing: IconButton(
                              icon: const Icon(Icons.undo),
                              onPressed: () => habitProvider.toggleHabit(originalIndex),
                            ),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(habit: habit))),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: const Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configure'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Personal Info'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reports'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              authProvider.logout();
            },
          ),
        ],
      ),
    );
  }
}