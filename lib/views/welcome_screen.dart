import 'package:flutter/material.dart';
import 'package:vdenis/views/quotes_screen.dart';
import 'package:vdenis/views/tasks_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;

  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido, $username!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TasksScreen(),
                  ),
                );
              },
              child: const Text('Lista de Tareas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuotesScreen(), // Cambia a la pantalla de configuración
                  ),
                );
              },
              child: const Text('Cotizaciones de Monedas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
