import 'package:flutter/material.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/constants/constants.dart';

class TaskToCompleteScreen extends StatelessWidget {
  final List<Task> tasks;
  final int initialIndex;

  const TaskToCompleteScreen({super.key, required this.tasks, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: construirTarjetaDeportiva(
              tasks[index],
              context,
            ),
          );
        },
      )
    );
  }

  Widget construirTarjetaDeportiva(Task task, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.all(10),
            child: 
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  'https://picsum.photos/200/300?random=${task.title.hashCode}',
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.getTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                for (String paso in task.getPasos!) // Itera sobre los pasos
                  Text(
                    paso,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                const SizedBox(height: 8),
                // Fecha límite
                Text(
                  FECHA_LIMITE + task.fechaLimiteToString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Descripción
                Text(
                  TASK_DESCRIPTION,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(task.getDescription),
              ],
            ),
          ),
        ],
      ),
    );
  }
}