import 'package:flutter/material.dart';
import 'package:flutter_project_1/screens/profile.dart';
import 'screens/login.dart';

void main() {
  runApp(const MyApp()); // This runs your Flutter app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(), // Start from login
    );
  }
}
