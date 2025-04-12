import 'package:flutter/material.dart';
import 'package:vdenis/views/login_screen.dart';
import 'package:vdenis/views/presentation/question/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }

  
}
