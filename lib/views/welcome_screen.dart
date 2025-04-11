import 'package:flutter/material.dart';
import 'package:vdenis/views/contador_screen.dart';
import 'package:vdenis/views/helpers/app_drawer.dart';
import 'package:vdenis/views/helpers/common_widgets_helper.dart';
import 'package:vdenis/views/quotes_screen.dart';
import 'package:vdenis/views/tasks_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonWidgetsHelper.buildBoldAppBarTitle('Bienvenido'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonWidgetsHelper.buildBoldTitle('¡Bienvenido!'),
            CommonWidgetsHelper.buildSpacing(height: 16),
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
            CommonWidgetsHelper.buildSpacing(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuotesScreen(),
                  ),
                );
              },
              child: const Text('Cotizaciones de Monedas'),
            ),
            CommonWidgetsHelper.buildSpacing(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContadorScreen(),
                  ),
                );
              },
              child: const Text('Contador'),
            ),
            CommonWidgetsHelper.buildSpacing(height: 16),
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
