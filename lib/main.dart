import 'package:flutter/material.dart';
import 'screens/login.dart'; // Import your welcome screen

void main() {
  runApp(const MyApp()); // This runs your Flutter app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the DEBUG banner
      title: 'Login App', // Title for the app (used by OS)
      theme: ThemeData(
        primarySwatch: Colors.blue, // Default theme color
      ),
      home: const LoginScreen(), // Set your first screen here
    );
  }
}
