import 'package:flutter/material.dart';
import 'package:vdenis/helpers/task_card_helper.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/constants/constantes.dart';

class TaskCard extends StatelessWidget {
  final Tarea tarea;
  final String imageUrl;
  final String fechaLimiteDato;
  final VoidCallback onBackPressed;

  const TaskCard({
    super.key,
    required this.tarea,
    required this.imageUrl,
    required this.fechaLimiteDato,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Borde sombreado
      color: Colors.white, // Color de fondo blanco
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Agrega un padding de 10 alrededor del Card
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen aleatoria
            ClipRRect(
              borderRadius: CommonWidgetsHelper.buildTopRoundedBorder(),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            CommonWidgetsHelper.buildSpacing(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                CommonWidgetsHelper.buildBoldTitle(tarea.titulo),
                CommonWidgetsHelper.buildSpacing(), // Espacio entre el título y la descripción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea el botón a la derecha
                  children: [
                    CommonWidgetsHelper.buildBoldFooter('${TareasConstantes.fechaLimite} $fechaLimiteDato'),
                    ElevatedButton.icon(
                      onPressed: onBackPressed,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Volver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}