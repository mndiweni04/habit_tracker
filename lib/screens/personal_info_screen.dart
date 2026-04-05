import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../country_list.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  // Linter Fix: Made the return type public to adhere to Dart best practices
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final StorageService _storage = StorageService();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  double _age = 25;
  String _selectedCountry = 'United States';
  List<String> _countries = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final list = await fetchCountries();
      if (mounted) {
        setState(() => _countries = list);
      }
    } catch (e) {
      debugPrint("Error loading countries: $e");
    }

    final creds = await _storage.getUserCredentials();
    final name = await _storage.getUserName();
    final age = await _storage.getAge();
    final country = await _storage.getCountry();

    if (mounted) {
      setState(() {
        _nameController.text = name;
        _usernameController.text = creds['username'] ?? '';
        _age = age >= 21 && age <= 100 ? age : 25;
        if (_countries.contains(country)) {
          _selectedCountry = country;
        } else if (_countries.isNotEmpty) {
          _selectedCountry = _countries.first;
        }
      });
    }
  }

  Future<void> _saveData() async {
    await _storage.setUserName(_nameController.text);
    await _storage.setAge(_age);
    await _storage.setCountry(_selectedCountry);
    
    final creds = await _storage.getUserCredentials();
    await _storage.saveUserCredentials(_usernameController.text, creds['email'] ?? '', creds['password'] ?? '');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Info"),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              label: 'Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _usernameController,
              label: 'Username',
              icon: Icons.alternate_email,
            ),
            const SizedBox(height: 24),
            Text(
              "Age: ${_age.round()}", 
              style: TextStyle(fontSize: 18, color: Colors.blue.shade700)
            ),
            Slider(
              value: _age,
              min: 21,
              max: 100,
              divisions: 79,
              activeColor: Colors.blue.shade600,
              inactiveColor: Colors.blue.shade300,
              onChanged: (val) => setState(() => _age = val),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade700),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: DropdownButton<String>(
                value: _countries.contains(_selectedCountry) ? _selectedCountry : null,
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text("Select Country"),
                items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCountry = val);
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                elevation: 5,
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade700),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}