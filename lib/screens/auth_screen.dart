import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (_isLogin) {
      auth.login(_emailController.text, _passwordController.text);
    } else {
      auth.register(_nameController.text, _emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HabitLoop", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            Text(_isLogin ? "Welcome Back" : "Create an Account", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 30),
            if (!_isLogin)
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email Address")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? "Enter HabitLoop" : "Sign Up"),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin ? "Need an account? Register" : "Have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}