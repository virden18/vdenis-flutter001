import '../domain/task.dart';

class TaskRepository {
  // Lista estática de tareas iniciales
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: 'urgente'),
    Task(title: 'Tarea 2'),
    Task(title: 'Tarea 3'),
    Task(title: 'Tarea 4', type: 'urgente'),
    Task(title: 'Tarea 5'),
  ];

  // Método para obtener todas las tareas
  List<Task> getTasks() {
    return _tasks;
  }
}