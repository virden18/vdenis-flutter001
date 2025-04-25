import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vdenis/views/login_screen.dart';
import 'package:vdenis/views/presentation/categoria/categoria_screen.dart';
import 'package:vdenis/views/presentation/noticia/noticia_screen.dart';

void main() async {
  // Inicializar dotenv antes de ejecutar la app
  await dotenv.load();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NoticiaScreen(),
    );
  }
}
