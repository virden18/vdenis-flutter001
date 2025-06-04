import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/auth/auth_bloc.dart';
import 'package:vdenis/bloc/auth/auth_event.dart';
import 'package:vdenis/data/preferencia_repository.dart';
import 'package:vdenis/views/login_screen.dart';
import 'package:get_it/get_it.dart';

class DialogHelper {

  static Future<bool?> mostrarConfirmacion({
    required BuildContext context, 
    required String titulo, 
    required String mensaje,
    String textoCancelar = 'Cancelar',
    String textoConfirmar = 'Confirmar',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(textoCancelar),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(textoConfirmar),
            ),
          ],
        );
      },
    );
  } 
  
  static void mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(              onPressed: () async {
                // Cerramos primero el diálogo
                Navigator.of(context).pop();
                
                // Obtener instancia del PreferenciaRepository para limpiar la caché
                final preferenciasRepo = GetIt.instance<PreferenciaRepository>();
                
                // Limpiar caché de preferencias ANTES del logout y redirección
                preferenciasRepo.invalidarCache();
                
                // Usar el BLoC para manejar el cierre de sesión
                if (context.mounted) {
                  BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
                }
                
                // Redireccionar a la pantalla de login, eliminando todas las pantallas del stack
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false, // Elimina todas las rutas previas
                  );
                }
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}