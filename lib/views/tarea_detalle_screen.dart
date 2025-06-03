import 'package:flutter/material.dart';
import 'package:vdenis/components/tarea_card.dart';
import 'package:vdenis/helpers/task_card_helper.dart';
import 'package:vdenis/domain/tarea.dart';

class TareaDetalleScreen extends StatelessWidget {
  final List<Tarea> tareas;
  final int indice;

  const TareaDetalleScreen({super.key, required this.tareas, required this.indice});

  @override
  Widget build(BuildContext context) {
    final Tarea tarea = tareas[indice];
    final String imageUrl = 'https://picsum.photos/200/300?random=$indice';
    final String fechaLimiteDato = tarea.fechaLimite != null
        ? '${tarea.fechaLimite!.day}/${tarea.fechaLimite!.month}/${tarea.fechaLimite!.year}'
        : 'Sin fecha límite';

    return Scaffold(
      backgroundColor: Colors.white,
      body: 
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! > 0) {
                  if (indice > 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TareaDetalleScreen(
                          tareas: tareas,
                          indice: indice - 1,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No hay tareas antes de esta tarea')),
                    );
                  }
                } else if (details.primaryVelocity! < 0) {
                  if (indice < tareas.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TareaDetalleScreen(
                          tareas: tareas,
                          indice: indice + 1,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CommonWidgetsHelper.buildNoStepsText(),
                      ),
                    );
                  }
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Center(
                child: TareaCard(
              tarea: tarea,
              imageUrl: imageUrl,
              fechaLimiteDato: fechaLimiteDato,
              onBackPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }
}