import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/data/asistant_repository.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/data/task_repository.dart';

class TaskService {
  
  final TaskRepository _taskRepository = TaskRepository(); // Instancia del repositorio
  final AssistantRepository _assistantRepository = AssistantRepository(); // Instancia del repositorio de asistente

  // Crear una nueva tarea
  void createTask(Task task) {
    print('Creando tarea: ${task.title}'); // Imprime el título de la tarea creada
    _taskRepository.addTask(task);// Agrega la tarea al repositorio
  }

  // Leer todas las tareas
  List<Task> getTasks() {
    print('Obteniendo tareas'); 
    List<Task> tasks = _taskRepository.getTasks();
    inicializarPasos(tasks);
    return tasks;
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
  List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    String fechaString = '${fechaLimite.day}/${fechaLimite.month}/${fechaLimite.year}';
    return _assistantRepository.obtenerPasos(titulo, fechaString); // Llama al método del repositorio
  }

  void inicializarPasos(List<Task> tasks) {
    for (Task task in tasks) {
      if (task.getPasos == null || task.getPasos!.isEmpty) {
        for (String paso in _assistantRepository.getListaPasos()) {
          task.getPasos!.add('$paso${task.getTitle} antes de ${task.fechaLimiteToString()}');
        }
      }
    }
  }
}