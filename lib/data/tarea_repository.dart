import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vdenis/api/service/tareas_service.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class TareasRepository {
  final TareaService _taskService = TareaService();

  /// Obtiene todas las tareas con pasos generados
  Future<List<Tarea>> obtenerTareas() async {
    try {
      // Obtener tareas de la API 
      debugPrint('🔄 Obteniendo tareas de la API');
      
      final tareasFromApi = await _taskService.getTasks();
      
      // Devuelve solo la cantidad solicitada
      return tareasFromApi.toList();
    } catch (e) {
      debugPrint('❌ Error al obtener tareas: $e');
      rethrow;
    }
  }

  /// Agrega una nueva tarea
  Future<Tarea> agregarTarea(Tarea tarea) async {
    try {
      // Crear la tarea con pasos
      final nuevaTarea = Tarea(
        id: tarea.id,
        titulo: tarea.titulo,
        tipo: tarea.tipo,
        descripcion: tarea.descripcion,
        fecha: tarea.fecha,
        fechaLimite: tarea.fechaLimite,
      );
      
      // Enviar a la API
      final tareaCreada = await _taskService.createTask(nuevaTarea);
      
      return tareaCreada;
    } catch (e) {
      debugPrint('❌ Error al agregar tarea: $e');
      rethrow;
    }
  }

  /// Elimina una tarea
  Future<void> eliminarTarea(String taskId) async {
    try {
      // Validar ID
      if (taskId.isEmpty) {
        throw ApiException('ID de tarea no válido');
      }

      // Eliminar de la API
      await _taskService.deleteTask(taskId);
 
      debugPrint('✅ Tarea eliminada: $taskId');
    } catch (e) {
      debugPrint('❌ Error al eliminar tarea: $e');
      rethrow;
    }
  }

  /// Actualiza una tarea existente
  Future<Tarea> actualizarTarea(String taskId, Tarea tareaActualizada) async {
    try {
      // Validar ID
      if (taskId.isEmpty) {
        throw ApiException('ID de tarea no válido');
      }
      
      // Crear la tarea actualizada con pasos
      final tareaConPasos = Tarea(
        id: taskId, // Asegurar que mantenemos el ID original
        titulo: tareaActualizada.titulo,
        tipo: tareaActualizada.tipo,
        descripcion: tareaActualizada.descripcion,
        fecha: tareaActualizada.fecha,
        fechaLimite: tareaActualizada.fechaLimite,
      );
      
      // Enviar a la API
      final tareaUpdated = await _taskService.updateTask(taskId, tareaConPasos);
      
      return tareaUpdated;
    } catch (e) {
      debugPrint('❌ Error al actualizar tarea: $e');
      rethrow;
    }
  }
}