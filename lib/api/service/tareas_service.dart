import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/domain/tarea.dart';

class TareaService extends BaseService {
  final String _endpoint = ApiConstantes.tareasEndpoint;

  Future<List<Tarea>> obtenerTareas(String usuario) async {
    final List<dynamic> tareasJson = await get<List<dynamic>>(
      '$_endpoint?usuario=$usuario',
      errorMessage: TareasConstantes.mensajeError,
    );

    return tareasJson
        .map<Tarea>((json) => TareaMapper.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  Future<Tarea> crearTarea(Tarea tarea) async {
    final json = await post(
      _endpoint,
      data: tarea.toMap(),
      errorMessage: TareasConstantes.errorCrear,
    );

    return TareaMapper.fromMap(json);
  }

  Future<void> eliminarTarea(String tareaId) async {
    final url = '$_endpoint/$tareaId';
    await delete(url, errorMessage: 'Error al eliminar la tarea');
  }

  Future<Tarea> actualizarTarea(Tarea tarea) async {
    final url = '$_endpoint/${tarea.id}';
    final json = await put(
      url,
      data: tarea.toMap(),
      errorMessage: TareasConstantes.errorActualizar,
    );

    return TareaMapper.fromMap(json);
  }
}
