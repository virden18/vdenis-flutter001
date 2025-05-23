import 'dart:async';
import 'package:vdenis/api/service/tareas_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/tarea.dart';

class TareasRepository extends BaseRepository<Tarea> {
  final TareaService _tareaService = TareaService();
  
  /// Valida los campos de la entidad Tarea
  @override
  void validarEntidad(Tarea tarea) {
    validarNoVacio(tarea.titulo, ValidacionConstantes.tituloNoticia);
    validarFechaNoFutura(
      tarea.fecha!,
      ValidacionConstantes.fechaNoticia,
    );
  }
  
  /// Obtiene todas las tareas con pasos generados
  Future<List<Tarea>> obtenerTareas() async {
    return manejarExcepcion(
      () => _tareaService.obtenerTareas(),
      mensajeError: TareasConstantes.mensajeError,
    );
  }

  /// Agrega una nueva tarea
  Future<Tarea> agregarTarea(Tarea tarea) async {
    return manejarExcepcion(
      () {
        validarEntidad(tarea);
        return _tareaService.crearTarea(tarea);
      },
      mensajeError: TareasConstantes.errorCrear,
    );
  }

  /// Elimina una tarea
  Future<void> eliminarTarea(String taskId) async {
    return manejarExcepcion(
      () {
        validarId(taskId);
        return _tareaService.eliminarTarea(taskId);
      },
      mensajeError: TareasConstantes.errorEliminar,
    );
  }

  /// Actualiza una tarea existente
  Future<Tarea> actualizarTarea(String taskId, Tarea tareaActualizada) async {
    return manejarExcepcion(
      () {
        validarId(taskId);
        validarEntidad(tareaActualizada);
        return _tareaService.actualizarTarea(taskId, tareaActualizada);
      },
      mensajeError: TareasConstantes.errorActualizar,
    );
  }
}