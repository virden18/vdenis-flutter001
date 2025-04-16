import 'package:flutter/material.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';
import 'package:vdenis/views/presentation/task/task_to_complete_screen.dart';

Widget buildTaskCard(
  List<Task> tasks,
  Task task,
  BuildContext context,
  int index, {
  required void Function(int) onEdit,
  required void Function(int) onDelete,
}) {
  return Dismissible(
    key: Key(task.title), // Usa el título como identificador único
    direction: DismissDirection.startToEnd,
    background: Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    ),
    onDismissed: (direction) {
      onDelete(index);  // Llama a la función para eliminar la tarea
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text(Constants.tareaEliminada),
        ),
      ); 
    },
    child: Card(
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Center( // Centra horizontalmente el contenido del Card
        child: ListTile(
          title: Text(task.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              const SizedBox(height: 4),
              Row(
                children: [
                  CommonWidgetsHelper.buildInfoLines(
                    '$Constants.tipoTarea${task.type}',
                    task.fechaToString(),
                  )
                ],
              ),
              if (task.pasos != null && task.pasos!.isNotEmpty)
                Text(
                  task.getPasos![0],
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              task.type == Constants.taskTypeUrgent
                  ? const Icon(
                      Icons.warning,
                      color: Colors.red,
                    )
                  : task.type == Constants.taskTypeNormal
                      ? const Icon(
                          Icons.task,
                          color: Colors.blue,
                        )
                      : const SizedBox(),
              IconButton(
                onPressed: () {
                  onEdit(index);
                },
                icon: const Icon(Icons.edit),
                color: Colors.black,
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskToCompleteScreen(
                  tasks: tasks, // Lista de tareas
                  initialIndex: index, // Índice de la tarea seleccionada
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}