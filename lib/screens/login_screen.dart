import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _handleLogin() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.login(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text('HabitLoop', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 30),
                _buildStyledInput(emailController, 'Enter Email', Icons.email),
                const SizedBox(height: 20),
                _buildStyledInput(passwordController, 'Enter Password', Icons.lock, obscure: true),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {}, child: const Text("Forgot password?", style: TextStyle(color: Colors.white))),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15)),
                  child: const Text('Log in', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                const Text('or', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                  child: const Text('Sign up', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledInput(TextEditingController controller, String hint, IconData icon, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.blue.shade700), hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
      ),
    );
  }
}