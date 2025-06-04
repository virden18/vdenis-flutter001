import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/bloc/tarea/tarea_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_event.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/tarea.dart';

class CommonWidgetsHelper {
  static Widget buildBoldTitle(String title, {bool isCompleted = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        decoration:
            isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        decorationThickness: 2.0,
        color: isCompleted ? Colors.grey : Colors.black,
      ),
    );
  }

  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    final List<String> lines = [
      line1,
      if (line2 != null) line2,
      if (line3 != null) line3,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          lines
              .map(
                (line) => Text(
                  line,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              )
              .toList(),
    );
  }

  static Widget buildBoldFooter(String footer) {
    return Text(
      footer,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  static RoundedRectangleBorder buildRoundedBorder() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
  }

  static Widget buildLeadingIcon(String type) {
    return Icon(
      type == 'normal' ? Icons.task : Icons.warning,
      color: type == 'normal' ? Colors.blue : Colors.red,
      size: 32,
    );
  }

  static Widget buildNoStepsText() {
    return const Text(
      'No hay pasos disponibles',
      style: TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

  static BorderRadius buildTopRoundedBorder({double radius = 8.0}) {
    return BorderRadius.vertical(top: Radius.circular(radius));
  }
}

Widget construirTarjetaDeportiva(
  BuildContext context,
  Tarea tarea,
  int indice,
  VoidCallback onEdit,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      tileColor: Colors.white,
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      leading: CommonWidgetsHelper.buildLeadingIcon(tarea.tipo),
      title: Row(
        children: [
          Checkbox(
            value: tarea.completada,
            activeColor: Colors.green,
            onChanged: (bool? newValue) {
              if (newValue != null && tarea.id != null) {
                context.read<TareaBloc>().add(
                  TareaCompletadaEvent(
                    tareaId: tarea.id!,
                    completada: newValue,
                  ),
                );
              }
            },
          ),
          Expanded(
            child: CommonWidgetsHelper.buildBoldTitle(
              tarea.titulo,
              isCompleted: tarea.completada,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: onEdit,
        icon: const Icon(Icons.edit, size: 16),
        style: ElevatedButton.styleFrom(foregroundColor: Colors.grey),
      ),
      subtitle: CommonWidgetsHelper.buildInfoLines(
        tarea.descripcion ?? '',
        '${TareasConstantes.tipoTarea}${tarea.tipo}',
        '${TareasConstantes.fechaLimite}${_formatDate(tarea.fechaLimite ?? DateTime.now())}',
      ),
    ),
  );
}

String _formatDate(DateTime date) {
  return DateFormat(AppConstantes.formatoFecha).format(date);
}
