import 'package:flutter/material.dart';
import 'package:vdenis/views/contador_screen.dart';
import 'package:vdenis/views/login_screen.dart';
import 'package:vdenis/views/tasks_screen.dart';
import 'package:vdenis/views/welcome_screen.dart';

class AppDrawer extends StatelessWidget {

  AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Menú de Navegación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TasksScreen(),
                ),
              );
            }
          ),
          ListTile(
            leading: const Icon(Icons.countertops),
            title: const Text('Contador'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContadorScreen()
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Salir'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()
                )
              );
            },
          ),
        ],
      ),
    );
  }
}