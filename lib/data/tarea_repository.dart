import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vdenis/api/service/task_service.dart';
import 'package:vdenis/data/assistant_repository.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class TareasRepository {
  final TaskService _taskService = TaskService();
  final AssistantRepository _assistantRepository = AssistantRepository();
  
  // Cache para minimizar llamadas a la API
  List<Task>? _cachedTasks;
  DateTime? _lastFetchTime;
  
  // Tiempo de validez de la caché (5 minutos)
  static const Duration _cacheValidity = Duration(minutes: 5);

  /// Verifica si la caché es válida
  bool _isCacheValid() {
    if (_cachedTasks == null || _lastFetchTime == null) {
      return false;
    }
    
    final now = DateTime.now();
    return now.difference(_lastFetchTime!) < _cacheValidity;
  }

  /// Obtiene todas las tareas con pasos generados
  Future<List<Task>> getTasksWithSteps({int limite = 4}) async {
    try {
      // Verificar si tenemos caché válida
      if (_isCacheValid() && _cachedTasks != null) {
        debugPrint('🟢 Usando caché para tareas');
        final tareas = _cachedTasks!.take(limite).toList();
        return tareas;
      }
      
      // Obtener tareas de la API
      debugPrint('🔄 Obteniendo tareas de la API');
      
      // Simula un retraso para imitar una llamada a una API si estamos en desarrollo
      if (kDebugMode) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      final tareasFromApi = await _taskService.getTasks();
      
      // Procesa las tareas con pasos
      final tareasWithSteps = await _addStepsToTasks(tareasFromApi);
      
      // Actualiza la caché
      _cachedTasks = tareasWithSteps;
      _lastFetchTime = DateTime.now();
      
      // Devuelve solo la cantidad solicitada
      return tareasWithSteps.take(limite).toList();
    } catch (e) {
      debugPrint('❌ Error al obtener tareas: $e');
      
      // Si hay un error y tenemos caché, usarla como fallback
      if (_cachedTasks != null) {
        debugPrint('⚠️ Usando caché expirada debido a error de red');
        return _cachedTasks!.take(limite).toList();
      }
      
      rethrow;
    }
  }

  /// Carga más tareas (paginación)
  Future<List<Task>> getMoreTasksWithSteps({required int inicio, int limite = 4}) async {
    try {
      // Verificar si ya tenemos todas las tareas en caché
      if (_isCacheValid() && _cachedTasks != null && _cachedTasks!.length > inicio) {
        debugPrint('🟢 Usando caché para paginación de tareas');
        final tareas = _cachedTasks!.skip(inicio).take(limite).toList();
        return tareas;
      }
      
      // Si no tenemos caché válida o es insuficiente, cargar todas las tareas nuevamente
      if (!_isCacheValid() || _cachedTasks == null) {
        debugPrint('🔄 Recargando todas las tareas para paginación');
        await getTasksWithSteps(limite: inicio + limite);
      }
      
      // Devuelve la porción solicitada
      return _cachedTasks!.skip(inicio).take(limite).toList();
    } catch (e) {
      debugPrint('❌ Error al obtener más tareas: $e');
      
      // Si hay un error y tenemos caché, usarla como fallback
      if (_cachedTasks != null && _cachedTasks!.length > inicio) {
        debugPrint('⚠️ Usando caché expirada debido a error de red');
        return _cachedTasks!.skip(inicio).take(limite).toList();
      }
      
      rethrow;
    }
  }

  /// Método para agregar pasos a las tareas
  Future<List<Task>> _addStepsToTasks(List<Task> tareas) async {
    debugPrint('🔄 Generando pasos para ${tareas.length} tareas');
    return await Future.wait(tareas.map((tarea) async {
      if (tarea.pasos == null || tarea.pasos!.isEmpty) {
        final pasos = await generarPasos(tarea.title, tarea.fechaLimite);
        return Task(
          id: tarea.id,
          title: tarea.title,
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
      final pasos = await generarPasos(tarea.title, tarea.fechaLimite);
      
      // Crear la tarea con pasos
      final nuevaTarea = Task(
        id: tarea.id,
        title: tarea.title,
        tipo: tarea.tipo,
        descripcion: tarea.descripcion,
        fecha: tarea.fecha,
        fechaLimite: tarea.fechaLimite,
        pasos: pasos,
      );
      
      // Simular delay en modo debug
      if (kDebugMode) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      // Enviar a la API
      final tareaCreada = await _taskService.createTask(nuevaTarea);
      
      // Actualizar la caché
      _cachedTasks?.add(tareaCreada);
      
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
      
      // Simular delay en modo debug
      if (kDebugMode) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      // Eliminar de la API
      await _taskService.deleteTask(taskId);
      
      // Actualizar la caché
      _cachedTasks?.removeWhere((tarea) => tarea.id == taskId);
      
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
      final pasos = await generarPasos(tareaActualizada.title, tareaActualizada.fechaLimite);
      
      // Crear la tarea actualizada con pasos
      final tareaConPasos = Task(
        id: taskId, // Asegurar que mantenemos el ID original
        title: tareaActualizada.title,
        tipo: tareaActualizada.tipo,
        descripcion: tareaActualizada.descripcion,
        fecha: tareaActualizada.fecha,
        fechaLimite: tareaActualizada.fechaLimite,
        pasos: pasos,
      );
      
      // Simular delay en modo debug
      if (kDebugMode) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      // Enviar a la API
      final tareaUpdated = await _taskService.updateTask(taskId, tareaConPasos);
      
      // Actualizar la caché
      if (_cachedTasks != null) {
        final index = _cachedTasks!.indexWhere((t) => t.id == taskId);
        if (index >= 0) {
          _cachedTasks![index] = tareaUpdated;
        }
      }
      
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
  /// Invalida la caché para forzar recarga
  void invalidarCache() {
    _cachedTasks = null;
    _lastFetchTime = null;
    debugPrint('🔄 Caché de tareas invalidada');
  }
}