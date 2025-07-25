import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, required this.child});

  final Widget child;

  static const double maxContentWidth = 600;

  bool _isDesktopPlatform() {
    // Platform checks only work outside web
    if (kIsWeb) return true;
    return Platform.isWindows || Platform.isMacOS;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopPlatform();

    return Scaffold(
      //appBar: AppBar(
        //backgroundColor: Colors.transparent,  //AppBar reserves space at top so make it transparent
        //elevation: 0,
      //),
      //extendBodyBehindAppBar: true, 
      body: Stack(
        children: [
        Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(33, 150, 243, 0.75) // 75% opacity for Colors.blue
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: isDesktop
                    ? const BoxConstraints(maxWidth: maxContentWidth, maxHeight: 720)
                    : const BoxConstraints(maxWidth: double.infinity, maxHeight: double.infinity),
                child: isDesktop
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue, // 90% transparent
                          borderRadius: BorderRadius.circular(20),

                        ),
                        child: child,
                      )
                    : child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
