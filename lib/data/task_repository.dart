import '../domain/task.dart';

class TaskRepository {
  // Lista estática de tareas iniciales
  final List<Task> tasks = [
    Task(title: 'Tarea 1', type: 'urgente'),
    Task(title: 'Tarea 2'),
    Task(title: 'Tarea 3'),
    Task(title: 'Tarea 4', type: 'urgente'),
    Task(title: 'Tarea 5'),
  ];

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
}