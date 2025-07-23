import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_1/db_helper.dart';
import '../widgets/custom_scaffold.dart';
import 'utils.dart'; // Make sure this import is correct
import 'signup_page.dart';
import 'profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildText('Welcome Back', fontSize: 32),
            const SizedBox(height: 10),
            buildText('Please Log in to your Account', fontSize: 16, isBold: true),
            const SizedBox(height: 30),

            buildCustomTextField(
              _emailController,
              const Key('emailField'),
              'Email',
              prefixIcon: const Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 30),

            buildCustomTextField(
              _passwordController,
              const Key('passwordField'),
              'Enter your Password',
              obscureText: _obscureText,
              suffixIconData: _obscureText ? Icons.visibility_off : Icons.visibility,
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text;

                if (email.isEmpty || password.isEmpty) {
                  _showMessage('Please fill in all fields');
                  return;
                } 
                if (getEmailValidationError(email)){
                  _showMessage('Please enter a valid email');
                  return;
                }

                final user = await DBHelper().getUser(email, password);
                if (user != null) {
                  _showMessage('Login Successful for ${user.email}');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                  );
                } else {
                  _showMessage('Invalid email or password');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Log In',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?", style: TextStyle(color: Colors.black)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
