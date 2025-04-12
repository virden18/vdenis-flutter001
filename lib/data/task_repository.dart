import 'package:vdenis/domain/task.dart';

class TaskRepository { 
  final List<Task> tasks;

  TaskRepository() : tasks = [] {
    tasks.addAll([
      Task(
        title: 'Tarea 1',
        type: 'urgente',
        description: 'Descripción de la tarea 1',
        date: DateTime(2024, 4, 7),
        deadLine: DateTime(2024, 4, 8),
        pasos: [],
      ),
      Task(
        title: 'Tarea 2',
        type: 'normal',
        description: 'Descripción de la tarea 2',
        date: DateTime(2024, 4, 8),
        deadLine: DateTime(2024, 4, 10),
        pasos: [],
      ),
      Task(
        title: 'Tarea 3',
        type: 'urgente',
        description: 'Descripción de la tarea 3',
        date: DateTime(2024, 4, 9),
        deadLine: DateTime(2024, 4, 11),
        pasos: [],
      ),
      Task(
        title: 'Tarea 4',
        type: 'normal',
        description: 'Descripción de la tarea 4',
        date: DateTime(2024, 4, 10),
        deadLine: DateTime(2024, 4, 14),
        pasos: [],
      ),
      Task(
        title: 'Tarea 5',
        type: 'urgente',
        description: 'Descripción de la tarea 5',
        date: DateTime(2024, 4, 11),
        deadLine: DateTime(2024, 4, 16),
        pasos: [],
      ),
      Task(
        title: 'Tarea 6',
        type: 'normal',
        description: 'Descripción de la tarea 6',
        date: DateTime(2024, 4, 12),
        deadLine: DateTime(2024, 4, 18),
        pasos: [],
      ),
      Task(
        title: 'Tarea 7',
        type: 'urgente',
        description: 'Descripción de la tarea 7',
        date: DateTime(2024, 4, 13),
        deadLine: DateTime(2024, 4, 20),
        pasos: [],
      ),
      Task(
        title: 'Tarea 8',
        type: 'normal',
        description: 'Descripción de la tarea 8',
        date: DateTime(2024, 4, 14),
        deadLine: DateTime(2024, 4, 22),
        pasos: [],
      ),
      Task(
        title: 'Tarea 9',
        type: 'urgente',
        description: 'Descripción de la tarea 9',
        date: DateTime(2024, 4, 15),
        deadLine: DateTime(2024, 4, 24),
        pasos: [],
      ),
    ]);
  }

  // Método para obtener todas las tareas
  List<Task> getTasks() {
    return tasks;
  }

  // Método para agregar una tarea
  void addTask(Task task) {
    tasks.add(task);
  }

  // Método para actualizar una tarea
  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = updatedTask;
    }
  }

  // Método para eliminar una tarea
  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
    }
  }

  Task getTaskById(int index) {
    if (index >= 0 && index < tasks.length) {
      return tasks[index];
    } else {
      throw Exception('Índice fuera de rango');
    }
  }

  void setListaPasos(List<String> pasos) {
    for (Task task in tasks) {
      if (task.getPasos == null || task.getPasos!.isEmpty) {
        task.setPasos(pasos);
      }
    }
  }

  String fechaToString(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  int getLength() {
    return tasks.length;
  }
}
