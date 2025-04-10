import '../domain/task.dart';

class TaskRepository { 
  final List<Task> tasks;

  TaskRepository() : tasks = [] {
    tasks.addAll([
      Task(
        title: 'Tarea 1',
        type: 'urgente',
        description: 'Descripción de la tarea 1',
        deadLine: DateTime(2024, 4, 7),
        fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 1)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 2',
        type: 'normal',
        description: 'Descripción de la tarea 2',
        deadLine: DateTime(2024, 4, 8),
        fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 2)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 3',
        type: 'urgente',
        description: 'Descripción de la tarea 3',
        deadLine: DateTime(2024, 4, 9),
        fechaLimite: DateTime(2024, 4, 9).add(Duration(days: 3)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 4',
        type: 'normal',
        description: 'Descripción de la tarea 4',
        deadLine: DateTime(2024, 4, 10),
        fechaLimite: DateTime(2024, 4, 10).add(Duration(days: 4)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 5',
        type: 'urgente',
        description: 'Descripción de la tarea 5',
        deadLine: DateTime(2024, 4, 11),
        fechaLimite: DateTime(2024, 4, 11).add(Duration(days: 5)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 6',
        type: 'normal',
        description: 'Descripción de la tarea 6',
        deadLine: DateTime(2024, 4, 12),
        fechaLimite: DateTime(2024, 4, 12).add(Duration(days: 6)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 7',
        type: 'urgente',
        description: 'Descripción de la tarea 7',
        deadLine: DateTime(2024, 4, 13),
        fechaLimite: DateTime(2024, 4, 13).add(Duration(days: 7)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 8',
        type: 'normal',
        description: 'Descripción de la tarea 8',
        deadLine: DateTime(2024, 4, 14),
        fechaLimite: DateTime(2024, 4, 14).add(Duration(days: 8)),
        pasos: [],
      ),
      Task(
        title: 'Tarea 9',
        type: 'urgente',
        description: 'Descripción de la tarea 9',
        deadLine: DateTime(2024, 4, 15),
        fechaLimite: DateTime(2024, 4, 15).add(Duration(days: 9)),
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
}
