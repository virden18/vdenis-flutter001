import 'package:vdenis/domain/task.dart';
import 'package:vdenis/data/task_repository.dart';

class TaskService {
  
  final TaskRepository _taskRepository = TaskRepository(); // Instancia del repositorio

  // Crear una nueva tarea
  void createTask(Task task) {
    print('Creando tarea: ${task.title}'); // Imprime el título de la tarea creada
    _taskRepository.addTask(task);// Agrega la tarea al repositorio
  }

  // Leer todas las tareas
  List<Task> getTasks() {
    print('Obteniendo tareas'); 
    return _taskRepository.getTasks();
  }

  void getTaskById(int index) {
    print('Obteniendo tarea por ID: $index'); // Imprime el índice de la tarea a obtener
    _taskRepository.getTaskById(index); 
  }

  // Actualizar una tarea existente
  void updateTask(int index, Task updatedTask) {
    print('Actualizando tarea en el índice: $index'); // Imprime el índice de la tarea actualizada
     _taskRepository.updateTask(index, updatedTask); 
  }

  // Eliminar una tarea
  void deleteTask(int index) {
    print('Eliminando tarea en el índice: $index'); // Imprime el índice de la tarea a eliminar
    _taskRepository.deleteTask(index); 
  }

  // Cargar más tareas
  List<Task> loadMoreTasks(int nextTaskId, int count) {
    return _taskRepository.loadMoreTasks(nextTaskId, count);
  }

  // Obtener pasos simulados para una tarea según su título
  List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    String fechaString = '${fechaLimite.day}/${fechaLimite.month}/${fechaLimite.year}';

    print('Obteniendo pasos para la tarea: $titulo');
    return [
      'Paso 1: Planificar $titulo antes de $fechaString',
      'Paso 2: Ejecutar $titulo antes de $fechaString',
      'Paso 3: Revisar $titulo antes de $fechaString',
    ];
  }
}