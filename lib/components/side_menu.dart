import 'package:flutter/material.dart';
import 'package:vdenis/helpers/dialog_helper.dart';
import 'package:vdenis/views/acercade_screen.dart';
import 'package:vdenis/views/contador_screen.dart';
import 'package:vdenis/views/mi_app_screen.dart';
import 'package:vdenis/views/noticia_screen.dart';
import 'package:vdenis/views/quote_screen.dart';
import 'package:vdenis/views/start_screen.dart';
import 'package:vdenis/views/tareas_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 17,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menú',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.newspaper,
            title: 'Noticias',
            onTap: () => _navigateTo(context, const NoticiaScreen()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.task,
            title: 'Tareas',
            onTap: () => _navigateTo(context, const TareaScreen()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.bar_chart,
            title: 'Cotizaciones',
            onTap: () => _navigateTo(context, const QuoteScreen()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.apps,
            title: 'Mi App',
            onTap: () => _navigateTo(context, const MiAppScreen()),
          ),     
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.numbers,
            title: 'Contador',
            onTap: () => _navigateTo(context, const ContadorScreen(title: 'Contador')),
          ),         
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.stars,
            title: 'Juego',
            onTap: () => _navigateTo(context, const StartScreen()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.info,
            title: 'Acerca de',
            onTap: () => _navigateTo(context, const AcercaDeScreen()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            icon: Icons.exit_to_app,
            title: 'Cerrar Sesión',
            onTap: () => DialogHelper.mostrarDialogoCerrarSesion(context),
            isSignOut: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSignOut = false,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSignOut 
            ? theme.colorScheme.error
            : theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSignOut ? theme.colorScheme.error : null,
          fontWeight: isSignOut ? FontWeight.bold : null,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}