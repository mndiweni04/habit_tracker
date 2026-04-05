import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../country_list.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  double _age = 25;
  String _selectedCountry = 'United States';
  List<String> _countries = [];
  final List<String> _selectedHabits = [];

  final List<String> _availableHabits = [
    'Wake Up Early', 'Workout', 'Drink Water', 'Meditate', 'Read a Book',
    'Practice Gratitude', 'Sleep 8 Hours', 'Eat Healthy', 'Journal', 'Walk 10,000 Steps'
  ];

  final Map<String, String> _habitColors = {
    'Amber': 'FFFFC107',
    'Red Accent': 'FFFF5252',
    'Light Blue': 'FF03A9F4',
    'Light Green': 'FF8BC34A',
    'Purple Accent': 'FFE040FB',
    'Orange': 'FFFF9800',
    'Teal': 'FF009688',
    'Deep Purple': 'FF673AB7',
  };

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final list = await fetchCountries();
      if (mounted) {
        setState(() {
          _countries = list;
          if (!_countries.contains(_selectedCountry)) {
            _selectedCountry = _countries.isNotEmpty ? _countries.first : 'United States';
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching countries: $e");
    }
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);
      
      final random = Random();
      final colorKeys = _habitColors.keys.toList();

      for (var habitTitle in _selectedHabits) {
        var randomColorName = colorKeys[random.nextInt(colorKeys.length)];
        var hexColor = _habitColors[randomColorName]!;
        
        habitProvider.addHabit(Habit(
          title: habitTitle,
          goal: 'Daily Habit',
          colorHex: hexColor,
        ));
      }

      auth.registerFullProfile(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        age: _age,
        country: _selectedCountry,
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInput(_nameController, 'Name', Icons.person, (val) => val == null || val.isEmpty ? 'Required' : null),
                const SizedBox(height: 10),
                _buildInput(_usernameController, 'Username', Icons.alternate_email, (val) => val == null || val.isEmpty ? 'Required' : null),
                const SizedBox(height: 10),
                _buildInput(_emailController, 'Email', Icons.email, (val) => val == null || val.isEmpty ? 'Required' : null),
                const SizedBox(height: 10),
                _buildInput(_passwordController, 'Password', Icons.lock, (val) => val == null || val.length < 6 ? 'Min 6 characters' : null, obscure: true),
                const SizedBox(height: 10),
                Text('Age: ${_age.round()}', style: const TextStyle(color: Colors.white, fontSize: 18)),
                Slider(
                  value: _age,
                  min: 21,
                  max: 100,
                  divisions: 79,
                  activeColor: Colors.blue.shade600,
                  inactiveColor: Colors.blue.shade300,
                  onChanged: (val) => setState(() => _age = val),
                ),
                const SizedBox(height: 10),
                _buildCountryDropdown(),
                const SizedBox(height: 15),
                const Text('Select Your Habits', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _availableHabits.map((habit) {
                    final isSelected = _selectedHabits.contains(habit);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected ? _selectedHabits.remove(habit) : _selectedHabits.add(habit);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.shade600 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade700),
                        ),
                        child: Text(
                          habit,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, IconData icon, String? Function(String?) validator, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          hintText: hint,
          border: InputBorder.none,
          errorStyle: const TextStyle(height: 0, color: Colors.transparent),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: DropdownButton<String>(
        value: _countries.contains(_selectedCountry) ? _selectedCountry : null,
        isExpanded: true,
        hint: const Text("Loading Countries..."),
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
        underline: const SizedBox(),
        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selectedCountry = val);
        },
      ),
    );
  }
}