import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_1/db_helper.dart';
import 'package:flutter_project_1/screens/services/email_validator_service.dart';
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
  String? _emailError;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _emailValidate(String email) {
    validateEmail(email, true, (error) {
      setState(() => _emailError = error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: buildText('Welcome Back', fontSize: 32)),
            const SizedBox(height: 50),
            Center(child:buildText(
              'Please Log in to your Account',
              fontSize: 16,
              isBold: true,
            )),
            const SizedBox(height: 20),

            buildCustomTextField(
              _emailController,
              const Key('emailField'),
              'Email',
              'Enter your email',
              errorText: _emailError,
              prefixIcon: const Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
              onChanged: _emailValidate,
            ),

            const SizedBox(height: 20),

            buildCustomTextField(
              _passwordController,
              const Key('passwordField'),
              'Password',
              'Enter your password',
              obscureText: _obscureText,
              suffixIconData:
                  _obscureText ? Icons.visibility_off : Icons.visibility,
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            const SizedBox(height:30),

            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text;

                if (email.isEmpty || password.isEmpty) {
                  _showMessage('Please fill in all fields');
                  return;
                } else if (_emailError != null) {
                  _showMessage(_emailError!);
                  return;
                }

                final user = await DBHelper().getUser(email, password);
                if (user != null) {
                  _showMessage('Login Successful for ${user.email}');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(user: user),
                    ),
                  );
                } else {
                  _showMessage('Invalid password');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 78, 136),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
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
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 6), // spacing between texts
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    
                    ),
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
