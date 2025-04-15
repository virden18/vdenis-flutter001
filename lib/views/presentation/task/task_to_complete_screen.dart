import 'package:flutter/material.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';

class TaskToCompleteScreen extends StatelessWidget {
  final List<Task> tasks;
  final int initialIndex;

  const TaskToCompleteScreen({super.key, required this.tasks, required this.initialIndex});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(tasks[initialIndex].getTitle), // Muestra el título de la tarea actual
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
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
      shape: CommonWidgetsHelper.buildRoundedBorder(),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
            padding: const EdgeInsets.all(16),
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
                CommonWidgetsHelper.buildSpacing(height: 8),
                for (String paso in task.getPasos!) // Itera sobre los pasos
                  Text(
                    paso,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                CommonWidgetsHelper.buildSpacing(height: 8),
                // Fecha límite
                Text(
                  fechaLimite + task.fechaLimiteToString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CommonWidgetsHelper.buildSpacing(height: 8),
                // Descripción
                const Text(
                  taskDescription,
                  style: TextStyle(
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