import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/data/asistant_repository.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/data/task_repository.dart';

class TaskService {
  
  final TaskRepository _taskRepository = TaskRepository(); // Instancia del repositorio
  final AssistantRepository _assistantRepository = AssistantRepository(); // Instancia del repositorio de asistente

  // Crear una nueva tarea
  void createTask(Task task) {
    //print('Creando tarea: ${task.title}'); // Imprime el título de la tarea creada
    _taskRepository.addTask(task);// Agrega la tarea al repositorio
  }

  // Leer todas las tareas
  List<Task> getTasks() {
    //print('Obteniendo tareas'); 
    List<Task> tasks = _taskRepository.getTasks();
    _inicializarPasos(tasks);
    return tasks;
  }

  void getTaskById(int index) {
    //print('Obteniendo tarea por ID: $index'); // Imprime el índice de la tarea a obtener
    _taskRepository.getTaskById(index); 
  }

  // Actualizar una tarea existente
  void updateTask(int index, Task updatedTask) {
    //print('Actualizando tarea en el índice: $index'); // Imprime el índice de la tarea actualizada
     _taskRepository.updateTask(index, updatedTask); 
  }

  // Eliminar una tarea
  void deleteTask(int index) {
    //print('$TAREA_ELIMINADA $index'); // Imprime el índice de la tarea a eliminar
    _taskRepository.deleteTask(index); 
  }

  // Cargar más tareas
  List<Task> loadMoreTasks(int nextTaskId, int count) {
    List<Task> newTasks = List.generate(
      count,
      (index) => Task(
        title: 'Tarea ${nextTaskId + index}',
        type: (index % 2) == 0 ? taskTypeNormal : taskTypeUrgent,
        description: 'Descripción de tarea ${nextTaskId + index}',
        date: DateTime.now().add(Duration(days: index)),
        deadLine: DateTime.now().add(Duration(days: index + 1)), 
        pasos: TaskService().getTaskWithSteps('Tarea ${nextTaskId + index}', DateTime.now().add(Duration(days: index + 1))),
      ),
    );
    return newTasks;
  }

  // Obtener pasos simulados para una tarea según su título
  List<String> getTaskWithSteps(String titulo, DateTime fechaLimite) {
    String fechaString = '${fechaLimite.day}/${fechaLimite.month}/${fechaLimite.year}';
    List<String> pasosSimulados = _assistantRepository.obtenerPasos(titulo, fechaString).take(limitePasos).toList(); // Limita los pasos simulados obtenidos
    _taskRepository.setListaPasos(pasosSimulados); // Establece la lista de pasos en el repositorio
    return pasosSimulados; // Devuelve la lista de pasos simulados
  }

  void _inicializarPasos(List<Task> tasks) {
    for (Task task in tasks) {
      if (task.getPasos == null || task.getPasos!.isEmpty) {
        getTaskWithSteps(task.getTitle, task.getFechaLimite);
      }
    }
  }
  
  int getCantidadTareas() {
    return _taskRepository.getLength();
  }
}