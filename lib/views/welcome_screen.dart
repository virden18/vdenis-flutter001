import 'package:flutter/material.dart';
import 'package:vdenis/views/quotes_screen.dart';

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
                // Aquí puedes agregar la navegación a la pantalla de cotizaciones
                // Por ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => QuotesScreen()));
              },
              child: const Text('Cotizaciones'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              child: const Text('Cerrar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para navegar a la pantalla de cotización
                // Por ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => QuoteScreen()));
              },
              child: const Text('boton cotizar'),
            ),
            const SizedBox(height: 16), // Espaciado entre los botones
            // Acción para mirar cotizaciones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            const QuotesScreen(), // Asegúrate de crear esta pantalla
                  ),
                );
              },
              child: const Text('Mirar Cotizaciones'),
            ),
            const SizedBox(height: 16), // Espaciado entre los botones
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para navegar a la pantalla de cotizaciones
                // Por ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => QuotesScreen()));
              },
              child: const Text('Mirar Cotizaciones de productos'),
            ),
          ],
        ),
      ),
    );
  }
}
