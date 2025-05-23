import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class TaskService extends BaseService {
  /// Obtiene la lista de tareas
  Future<List<Task>> getTasks() async {
    try {
      final List<dynamic> tareasJson = await get<List<dynamic>>(
        ApiConstantes.tareasEndpoint,
        errorMessage: 'Error al obtener las tareas',
      );

      return tareasJson
          .map<Task>((json) => TaskMapper.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al obtener las tareas: ${e.toString()}');
    }
  }

  /// Crea una nueva tarea
  Future<Task> createTask(Task task) async {
    final endpoint = ApiConstantes.tareasEndpoint;
    
    try {
      final json = await post(
        endpoint,
        data: task.toMap(),
        errorMessage: 'Error al crear la tarea',
      );
      
      return TaskMapper.fromMap(json);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al crear la tarea: ${e.toString()}');
    }
  }

    /// Elimina una tarea existente
  Future<void> deleteTask(String taskId) async {
    final endpoint = '${ApiConstantes.tareasEndpoint}/$taskId';
    
    try {
      await delete(
        endpoint,
        errorMessage: 'Error al eliminar la tarea',
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al eliminar la tarea: ${e.toString()}');
    }
  }

   /// Actualiza una tarea existente
  Future<Task> updateTask(String taskId, Task task) async {
    final endpoint = '${ApiConstantes.tareasEndpoint}/$taskId';
    
    try {
      final json = await put(
        endpoint,
        data: task.toMap(),
        errorMessage: 'Error al actualizar la tarea',
      );
      
      return TaskMapper.fromMap(json);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al actualizar la tarea: ${e.toString()}');
    }
  }
}
