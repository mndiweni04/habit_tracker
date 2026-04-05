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
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      
      if (emailController.text.trim() == 'testuser' && passwordController.text == 'password123') {
        await auth.loginHardcoded();
        return;
      }
      
      final success = await auth.login(emailController.text.trim(), passwordController.text);
      
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Habitt', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 30),
                  _buildValidatedInput(
                    controller: emailController, 
                    hint: 'Enter Username or Email', 
                    icon: Icons.email,
                    validator: (value) => value == null || value.isEmpty ? 'Field cannot be empty' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildValidatedInput(
                    controller: passwordController, 
                    hint: 'Enter Password', 
                    icon: Icons.lock, 
                    obscure: true,
                    validator: (value) => value == null || value.isEmpty ? 'Password cannot be empty' : null,
                  ),
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
      ),
    );
  }

  Widget _buildValidatedInput({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon, 
    bool obscure = false,
    required String? Function(String?) validator
  }) {
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
        ),
      ),
    );
  }
}