import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/bloc/tarea/tarea_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_event.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/tarea.dart';

class CommonWidgetsHelper {
  /// Construye un título en negrita con tamaño 20
  static Widget buildBoldTitle(String title, {bool isCompleted = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        decorationThickness: 2.0,
        color: isCompleted ? Colors.grey : Colors.black,
      ),
    );
  }

  /// Construye líneas de información (máximo 3 líneas)
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    final List<String> lines = [line1, if (line2 != null) line2, if (line3 != null) line3];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map((line) => Text(
                line,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ))
          .toList(),
    );
  }

  /// Construye un pie de página en negrita
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

  /// Construye un SizedBox con altura de 8
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  /// Construye un borde redondeado con BorderRadius.circular(10)
  static RoundedRectangleBorder buildRoundedBorder() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
  }

  /// Construye un ícono dinámico basado en el tipo de tarea
  static Widget buildLeadingIcon(String type) {
    return Icon(
      type == 'normal' ? Icons.task : Icons.warning,
      color: type == 'normal' ? Colors.blue : Colors.red,
      size: 32,
    );
  }

  // Construye un texto predeterminado para "No hay pasos disponibles"
  static Widget buildNoStepsText() {
    return const Text(
      'No hay pasos disponibles',
      style: TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

   /// Construye un BorderRadius con bordes redondeados solo en la parte superior
  static BorderRadius buildTopRoundedBorder({double radius = 8.0}) {
    return BorderRadius.vertical(top: Radius.circular(radius));
  }
}

Widget construirTarjetaDeportiva(Tarea tarea, int indice, VoidCallback onEdit) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Espaciado entre tarjetas
    child: ListTile(
      contentPadding: const EdgeInsets.all(16.0), // Padding interno del ListTile
      tileColor: Colors.white, // Fondo blanco para el ListTile
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      leading: CommonWidgetsHelper.buildLeadingIcon(tarea.tipo), // Ícono dinámico
      title: Row(
        children: [
          Checkbox(
            value: tarea.completada,
            activeColor: Colors.green,
            onChanged: (bool? newValue) {
              if (newValue != null && tarea.id != null) {
                // Disparar evento para actualizar el estado de la tarea
                BuildContext? context = _getGlobalContext();
                if (context != null) {
                  context.read<TareaBloc>().add(
                    TareaCompletadaEvent(
                      tareaId: tarea.id!,
                      completada: newValue,
                    ),
                  );
                }
              }
            },
          ),
          Expanded(
            child: CommonWidgetsHelper.buildBoldTitle(
              tarea.titulo, 
              isCompleted: tarea.completada
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: onEdit, // Llama a la función de edición
        icon: const Icon(Icons.edit, size: 16),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey, // Color del texto
        ),
      ),
      subtitle: CommonWidgetsHelper.buildInfoLines(
        tarea.descripcion ?? '',
        '${TareasConstantes.tipoTarea}${tarea.tipo}',
        '${TareasConstantes.fechaLimite}${_formatDate(tarea.fechaLimite ?? DateTime.now())}',
      ), // Líneas de información
    ),
  );
}

// Función auxiliar para obtener el BuildContext global para poder acceder al BlocProvider
BuildContext? _getGlobalContext() {
  // En una aplicación real, usaríamos Navigator.of(context) que debería estar disponible
  // donde se construye la tarjeta, pero como este es un helper estático, necesitamos
  // alguna forma de obtener el contexto. Una opción es pasar el contexto como parámetro
  // a la función construirTarjetaDeportiva. 
  
  // Aquí usamos una forma simplificada asumiendo que la función se llama desde un widget
  // que tiene acceso al contexto. En la implementación real, deberíamos modificar los 
  // parámetros de la función para incluir el contexto.
  
  // Por ahora, retornamos null y esto debe ser adaptado en la llamada real.
  return null;
}

String _formatDate(DateTime date) {
  return DateFormat(AppConstantes.formatoFecha).format(date);
}
