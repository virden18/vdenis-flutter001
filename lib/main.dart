import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vdenis/di/locator.dart';
import 'package:vdenis/views/login_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");// Inicializar dotenv antes de ejecutar la app
  await initLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: LoginScreen(),
      );
  }
}
