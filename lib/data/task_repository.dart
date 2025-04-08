import '../domain/task.dart';
import '../constants/constants.dart';
import '../api/service/task_service.dart';

class TaskRepository {
  // Lista estática de tareas iniciales
  final List<Task> tasks = [
    Task(
      title: 'Tarea 1',
      type: 'urgente',
      description: 'Descripción de la tarea 1',
      date: DateTime(2024, 4, 7),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 1)),
      pasos: obtenerPasos('Tarea 1', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 2',
      type: 'normal',
      description: 'Descripción de la tarea 2',
      date: DateTime(2024, 4, 8),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 2)),
      pasos: obtenerPasos('Tarea 2', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 3',
      type: 'urgente',
      description: 'Descripción de la tarea 3',
      date: DateTime(2024, 4, 9),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 3)),
      pasos: obtenerPasos('Tarea 3', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 4',
      type: 'normal',
      description: 'Descripción de la tarea 4',
      date: DateTime(2024, 4, 10),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 4)),
      pasos: obtenerPasos('Tarea 4', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 5',
      type: 'urgente',
      description: 'Descripción de la tarea 5',
      date: DateTime(2024, 4, 11),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 5)),
      pasos: obtenerPasos('Tarea 5', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 6',
      type: 'normal',
      description: 'Descripción de la tarea 6',
      date: DateTime(2024, 4, 11),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 6)),
      pasos: obtenerPasos('Tarea 6', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 7',
      type: 'urgente',
      description: 'Descripción de la tarea 7',
      date: DateTime(2024, 4, 9),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 7)),
      pasos: obtenerPasos('Tarea 7', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 8',
      type: 'normal',
      description: 'Descripción de la tarea 8',
      date: DateTime(2024, 4, 10),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 8)),
      pasos: obtenerPasos('Tarea 8', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
    Task(
      title: 'Tarea 9',
      type: 'urgente',
      description: 'Descripción de la tarea 9',
      date: DateTime(2024, 4, 11),
      fechaLimite: DateTime(2024, 4, 8).add(Duration(days: 9)),
      pasos: obtenerPasos('Tarea 9', DateTime(2024, 4, 8).add(Duration(days: 1))),
    ),
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

  Task getTaskById(int index) {
    if (index >= 0 && index < tasks.length) {
      return tasks[index];
    } else {
      throw Exception('Índice fuera de rango');
    }
  }

  // Cargar más tareas (simulación)
  List<Task> loadMoreTasks(int nextTaskId, int count) {
    return List.generate(
      count,
      (index) => Task(
        title: 'Tarea ${nextTaskId + index}',
        type: (index % 2) == 0 ? TASK_TYPE_NORMAL : TASK_TYPE_URGENT,
        description: 'Descripción de tarea ${nextTaskId + index}',
        date: DateTime.now().add(Duration(days: index)),
        fechaLimite: DateTime.now().add(Duration(days: index + 1)), 
        pasos: TaskService().obtenerPasos('Tarea ${nextTaskId + index}', DateTime.now().add(Duration(days: index + 1))),
      ),
    );
  }

  // Obtener pasos simulados para una tarea según su título
  static List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    print('Obteniendo pasos para la tarea: $titulo');
    return [
      'Paso 1: Planificar $titulo',
      'Paso 2: Ejecutar $titulo',
      'Paso 3: Revisar $titulo',
    ];
  }
}