import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/contador_bloc/contador_bloc.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';
import 'package:vdenis/views/presentation/misc/contador_screen.dart';
import 'package:vdenis/views/login_screen.dart';
import 'package:vdenis/views/presentation/noticia/noticia_screen.dart';
import 'package:vdenis/views/presentation/quote/quote_screen.dart';
import 'package:vdenis/views/presentation/task/tasks_screen.dart';
import 'package:vdenis/views/presentation/question/start_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
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
            child: CommonWidgetsHelper.buildTitle('Menu de Navegación'),
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TasksScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.countertops),
            title: const Text('Contador'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create: (context) => ContadorBloc(),
                        child: const ContadorScreen(),
                      ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text('Juego de preguntas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StartScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Cotizaciones'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuoteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('Noticias'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NoticiaScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Salir'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
