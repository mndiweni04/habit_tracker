import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  double _age = 25.0;
  String _country = 'United States';
  List<String> selectedHabits = [];
  final List<String> availableHabits = ['Wake Up Early', 'Workout', 'Drink Water', 'Meditate', 'Read a Book', 'Journal'];

  void _handleRegister() {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.register(_nameController.text, _emailController.text, _passwordController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), backgroundColor: Colors.blue.shade700, elevation: 0),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade700, Colors.blue.shade900], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(_nameController, 'Name', Icons.person),
              const SizedBox(height: 10),
              _buildField(_usernameController, 'Username', Icons.alternate_email),
              const SizedBox(height: 20),
              Text('Age: ${_age.round()}', style: const TextStyle(color: Colors.white, fontSize: 18)),
              Slider(value: _age, min: 21, max: 100, divisions: 79, activeColor: Colors.blue.shade600, onChanged: (v) => setState(() => _age = v)),
              const SizedBox(height: 10),
              _buildDropdown(),
              const SizedBox(height: 20),
              const Text('Select Your Habits', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10, runSpacing: 10,
                children: availableHabits.map((habit) {
                  final isSelected = selectedHabits.contains(habit);
                  return GestureDetector(
                    onTap: () => setState(() => isSelected ? selectedHabits.remove(habit) : selectedHabits.add(habit)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(color: isSelected ? Colors.blue.shade600 : Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Text(habit, style: TextStyle(color: isSelected ? Colors.white : Colors.blue.shade700)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(onPressed: _handleRegister, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15)), child: const Text('Register', style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon) {
    return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)), child: TextField(controller: ctrl, decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.blue.shade700), hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15))));
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: DropdownButton<String>(
        value: _country, isExpanded: true, underline: const SizedBox(),
        items: ['United States', 'Canada', 'United Kingdom', 'Australia', 'South Africa'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => _country = v!),
      ),
    );
  }
}