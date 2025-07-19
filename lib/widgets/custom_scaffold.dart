import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(                          //Scaffold()  gives basic structiure for our app
      appBar: AppBar(
        backgroundColor: Colors.transparent,  //AppBar reserves space at top so make it transparent
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,           //to extend the bg behind the AppBar
      body: Stack(
        children: [                           //body can have many components
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(                           // so that the text is inside the frame
            child: child!,
          )
        ],
      ),
    );
  }
}
