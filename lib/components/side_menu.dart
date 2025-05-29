import 'package:flutter/material.dart';
import 'package:vdenis/helpers/dialog_helper.dart';
import 'package:vdenis/views/acercade_screen.dart';
import 'package:vdenis/views/contador_screen.dart';
import 'package:vdenis/views/mi_app_screen.dart';
import 'package:vdenis/views/noticia_screen.dart';
import 'package:vdenis/views/quote_screen.dart';
import 'package:vdenis/views/start_screen.dart';
import 'package:vdenis/views/welcome_screen.dart';
import 'package:vdenis/views/tareas_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 80, // To change the height of DrawerHeader
            child: DrawerHeader(
              decoration:  BoxDecoration(color: Color.fromARGB(255, 217, 162, 180)),
              margin: EdgeInsets.zero, // Elimina el margen predeterminado
              padding: EdgeInsets.symmetric(horizontal: 18.0), // Elimina el padding interno
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menú ',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Cotizaciones'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuoteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TareaScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper), // Ícono para la nueva opción
            title: const Text('Noticias'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NoticiaScreen()), // Navega a MiAppScreen
              );
            },
          ),      
          ListTile(
            leading: const Icon(Icons.apps), // Ícono para la nueva opción
            title: const Text('Mi App'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MiAppScreen()), // Navega a MiAppScreen
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.numbers), // Ícono para el contador
            title: const Text('Contador'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContadorScreen(title: 'Contador'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.stars), // Ícono para el contador
            title: const Text('Juego'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info), // Ícono para el contador
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AcercaDeScreen()),
              );
            },
          ),          
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              DialogHelper.mostrarDialogoCerrarSesion(context);
            },
          ),
        ],
      ),
    );
  }
}