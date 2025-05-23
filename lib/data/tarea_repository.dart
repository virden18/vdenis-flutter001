import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vdenis/api/service/tareas_service.dart';
import 'package:vdenis/data/assistant_repository.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class TareasRepository {
  final TareaService _taskService = TareaService();
  final AssistantRepository _assistantRepository = AssistantRepository();

  /// Obtiene todas las tareas con pasos generados
  Future<List<Task>> obtenerTareas({int limite = 4}) async {
    try {
      // Obtener tareas de la API 
      debugPrint('🔄 Obteniendo tareas de la API');
      
      final tareasFromApi = await _taskService.getTasks();
      
      // Procesa las tareas con pasos
      final tareasWithSteps = await _addStepsToTasks(tareasFromApi);
      
      // Devuelve solo la cantidad solicitada
      return tareasWithSteps.take(limite).toList();
    } catch (e) {
      debugPrint('❌ Error al obtener tareas: $e');
      rethrow;
    }
  }

  /// Método para agregar pasos a las tareas
  Future<List<Task>> _addStepsToTasks(List<Task> tareas) async {
    debugPrint('🔄 Generando pasos para ${tareas.length} tareas');
    return await Future.wait(tareas.map((tarea) async {
      if (tarea.pasos == null || tarea.pasos!.isEmpty) {
        final pasos = await generarPasos(tarea.titulo, tarea.fechaLimite);
        return Task(
          id: tarea.id,
          titulo: tarea.titulo,
          tipo: tarea.tipo,
          descripcion: tarea.descripcion,
          fecha: tarea.fecha,
          fechaLimite: tarea.fechaLimite,
          pasos: pasos,
        );
      }
      return tarea;
    }));
  }

  /// Agrega una nueva tarea
  Future<Task> agregarTarea(Task tarea) async {
    try {
      // Generar pasos para la tarea
      final pasos = await generarPasos(tarea.titulo, tarea.fechaLimite);
      
      // Crear la tarea con pasos
      final nuevaTarea = Task(
        id: tarea.id,
        titulo: tarea.titulo,
        tipo: tarea.tipo,
        descripcion: tarea.descripcion,
        fecha: tarea.fecha,
        fechaLimite: tarea.fechaLimite,
        pasos: pasos,
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
  Future<Task> actualizarTarea(String taskId, Task tareaActualizada) async {
    try {
      // Validar ID
      if (taskId.isEmpty) {
        throw ApiException('ID de tarea no válido');
      }
      
      // Generar pasos actualizados
      final pasos = await generarPasos(tareaActualizada.titulo, tareaActualizada.fechaLimite);
      
      // Crear la tarea actualizada con pasos
      final tareaConPasos = Task(
        id: taskId, // Asegurar que mantenemos el ID original
        titulo: tareaActualizada.titulo,
        tipo: tareaActualizada.tipo,
        descripcion: tareaActualizada.descripcion,
        fecha: tareaActualizada.fecha,
        fechaLimite: tareaActualizada.fechaLimite,
        pasos: pasos,
      );
      
      // Enviar a la API
      final tareaUpdated = await _taskService.updateTask(taskId, tareaConPasos);
      
      return tareaUpdated;
    } catch (e) {
      debugPrint('❌ Error al actualizar tarea: $e');
      rethrow;
    }
  }

  /// Genera pasos para una tarea basados en su título y fecha límite
  Future<List<String>> generarPasos(String titulo, DateTime? fechaLimite) async {
    try {
      final pasos = await _assistantRepository.generarPasos(titulo, fechaLimite);
      
      // Limitar a 2 pasos como máximo
      final limitedPasos = pasos.take(2).toList();
      
      return limitedPasos;
    } catch (e) {
      debugPrint('❌ Error al generar pasos: $e');
      return ['Paso 1', 'Paso 2']; // Pasos genéricos como fallback
    }
  }
}