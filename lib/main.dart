import 'package:flutter/material.dart';
import 'package:flutter_project_1/screens/profile.dart';
import 'package:flutter_project_1/user_model.dart';
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
      title: 'MyProfile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ProfilePage(
        user: User(id: 1, email: 'test@example.com', password: 'password123'),
      ), // Start from login
    );
  }
}
