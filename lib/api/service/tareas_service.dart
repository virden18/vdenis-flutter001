import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/domain/tarea.dart';

class TareaService extends BaseService {
  final String _endpoint = '${ApiConstantes.tareasEndpoint}virgilio';

  /// Obtiene la lista de tareas
  Future<List<Tarea>> obtenerTareas() async {
    final List<dynamic> tareasJson = await get<List<dynamic>>(
      _endpoint,
      errorMessage: 'Error al obtener las tareas',
    );

    return tareasJson
        .map<Tarea>((json) => TareaMapper.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  /// Crea una nueva tarea
  Future<Tarea> crearTarea(Tarea task) async {
    final json = await post(
      _endpoint,
      data: task.toMap(),
      errorMessage: 'Error al crear la tarea',
    );

    return TareaMapper.fromMap(json);
  }

  /// Elimina una tarea existente
  Future<void> eliminarTarea(String taskId) async {
    final url = '$_endpoint/$taskId';
    await delete(url, errorMessage: 'Error al eliminar la tarea');
  }

  /// Actualiza una tarea existente
  Future<Tarea> actualizarTarea(String taskId, Tarea task) async {
    final url = '$_endpoint/$taskId';
    final json = await put(
      url,
      data: task.toMap(),
      errorMessage: 'Error al actualizar la tarea',
    );

    return TareaMapper.fromMap(json);
  }
}
