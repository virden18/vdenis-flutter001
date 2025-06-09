import 'package:flutter/material.dart';
import 'package:vdenis/components/side_menu.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:vdenis/views/login_screen.dart'; // Añadimos la importación de LoginScreen
import 'package:watch_it/watch_it.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  String _userEmail = '';
  @override
  void initState() {
    super.initState();
    _verificarAutenticacionYCargarEmail();
  }

  Future<void> _verificarAutenticacionYCargarEmail() async {
    final SecureStorageService secureStorage = di<SecureStorageService>();
    
    // Verificar si hay un token válido
    final token = await secureStorage.getJwt();
    
    // Si no hay token, redireccionar a la pantalla de login
    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Elimina todas las rutas previas
        );
      }
      return;
    }
    
    // Si hay token, cargar el email del usuario
    final email = await secureStorage.getUserEmail() ?? 'Usuario';
    if (mounted) {
      setState(() {
        _userEmail = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido, $_userEmail',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Has iniciado sesión correctamente.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
    ),
    );
  }
}
