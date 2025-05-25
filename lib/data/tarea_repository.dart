import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vdenis/api/service/tareas_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/core/services/tarea_cache_service.dart';
import 'package:vdenis/data/auth_repository.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:watch_it/watch_it.dart';

class TareasRepository extends BaseRepository<Tarea> {
  final TareaService _tareaService = TareaService();
  final TareaCacheService _cacheService = TareaCacheService();
  
  /// Valida los campos de la entidad Tarea
  @override
  void validarEntidad(Tarea tarea) {
    validarNoVacio(tarea.titulo, ValidacionConstantes.tituloNoticia);
    if (tarea.fecha != null) {
      validarFechaNoFutura(
        tarea.fecha!,
        ValidacionConstantes.fechaNoticia,
      );
    }
  }
    /// Obtiene todas las tareas con estrategia cache-first, filtrando por el email del usuario actual
  Future<List<Tarea>> obtenerTareas({bool forzarRecarga = false}) async {
    return manejarExcepcion(() async {
      // Obtenemos el email del usuario actual para filtrar las tareas
      final String? emailUsuario = await di<AuthRepository>().getUserEmail();
      if (emailUsuario == null || emailUsuario.isEmpty) {
        // Si no hay usuario autenticado, retornamos lista vacía
        debugPrint('No hay usuario autenticado, retornando lista de tareas vacía');
        return [];
      }
      
      // Si se fuerza la recarga, ignoramos la caché
      List<Tarea> tareas;
      if (forzarRecarga) {
        tareas = await _cargarDesdeLaAPI();
      } else {
        // Intentamos obtener los datos desde la caché primero
        final tareasDesdeCachee = await _cacheService.obtenerTareas();
        
        // Si tenemos datos en caché, los usamos
        if (tareasDesdeCachee != null && tareasDesdeCachee.isNotEmpty) {
          debugPrint('Tareas cargadas desde la caché local');
          tareas = tareasDesdeCachee;
        } else {
          // Si no hay caché, cargamos desde la API
          tareas = await _cargarDesdeLaAPI();
        }
      }
      
      // Filtramos las tareas por el email del usuario actual
      final List<Tarea> tareasFiltradas = tareas.where((tarea) => 
        tarea.usuario == emailUsuario
      ).toList();
      
      debugPrint('Filtrando tareas por email: $emailUsuario. Total: ${tareasFiltradas.length}');
      return tareasFiltradas;
    }, mensajeError: TareasConstantes.mensajeError);
  }
  /// Carga las tareas desde la API y actualiza la caché
  Future<List<Tarea>> _cargarDesdeLaAPI() async {
    final tareas = await _tareaService.obtenerTareas();
    // Actualizamos la caché
    await _cacheService.guardarTareas(tareas);
    await _cacheService.actualizarTimestamp();
    debugPrint('Tareas cargadas desde la API y guardadas en caché. Total: ${tareas.length}');
    return tareas;
  }/// Agrega una nueva tarea y actualiza la caché
  Future<Tarea> agregarTarea(Tarea tarea) async {
    return manejarExcepcion(
      () async {
        // Validamos y nos aseguramos que la tarea tenga el email del usuario actual
        validarEntidad(tarea);
        
        // Verificamos si ya tiene email, de lo contrario lo obtenemos
        final tareaConEmail = tarea.usuario == null || tarea.usuario!.isEmpty
          ? Tarea(
              titulo: tarea.titulo,
              tipo: tarea.tipo,
              descripcion: tarea.descripcion,
              fecha: tarea.fecha,
              fechaLimite: tarea.fechaLimite,
              usuario: await di<AuthRepository>().getUserEmail() ?? 'usuario@anonimo.com'
            )
          : tarea;
            // Enviamos la tarea a la API
        final nuevaTarea = await _tareaService.crearTarea(tareaConEmail);
        
        // Actualizamos solo la caché local sin hacer GET adicional
        final tareasCacheadas = await _cacheService.obtenerTareas() ?? [];
      
        final nuevasTareas = [nuevaTarea, ...tareasCacheadas];
        
        // Guardamos la caché actualizada
        await _cacheService.guardarTareas(nuevasTareas);
        await _cacheService.actualizarTimestamp();
        
        debugPrint('Tarea creada y caché actualizada, ID: ${nuevaTarea.id}');
        
        return nuevaTarea;
      },
      mensajeError: TareasConstantes.errorCrear,
    );
  }

  /// Elimina una tarea y actualiza la caché
  Future<void> eliminarTarea(String taskId) async {
    return manejarExcepcion(
      () async {
        validarId(taskId);        // Eliminamos la tarea en la API
        await _tareaService.eliminarTarea(taskId);
        
        // Actualizamos solo la caché local sin hacer GET adicional
        final tareasCacheadas = await _cacheService.obtenerTareas() ?? [];
        
        // Filtramos la tarea eliminada de la caché
        final tareasFiltradas = tareasCacheadas.where((t) => t.id != taskId).toList();
        
        // Guardamos la caché actualizada
        await _cacheService.guardarTareas(tareasFiltradas);
        await _cacheService.actualizarTimestamp();
        
        debugPrint('Tarea eliminada y caché actualizada, ID: $taskId');
      },
      mensajeError: TareasConstantes.errorEliminar,
    );
  }
  /// Actualiza una tarea existente y la caché
  Future<Tarea> actualizarTarea(String taskId, Tarea tareaActualizada) async {
    return manejarExcepcion(      () async {
        validarId(taskId);
        validarEntidad(tareaActualizada);
        
        // Obtenemos las tareas desde la caché local, no de la API
        final tareasCacheadas = await _cacheService.obtenerTareas() ?? [];
        
        // Buscamos la tarea original para preservar el email si no se ha proporcionado
        final tareaOriginal = tareasCacheadas.firstWhere(
          (t) => t.id == taskId,
          orElse: () => Tarea(titulo: '', usuario: '') // Tarea vacía si no se encuentra
        );
        
        // Asegurar que se mantiene el email original
        final String email = (tareaActualizada.usuario != null && tareaActualizada.usuario!.isNotEmpty) ?
            tareaActualizada.usuario! :
            (tareaOriginal.usuario ?? await di<AuthRepository>().getUserEmail() ?? 'usuario@anonimo.com');
            
        // Crear objeto con el email asegurado
        final tareaConEmail = Tarea(
          id: taskId,
          titulo: tareaActualizada.titulo,
          tipo: tareaActualizada.tipo,
          descripcion: tareaActualizada.descripcion,
          fecha: tareaActualizada.fecha,
          fechaLimite: tareaActualizada.fechaLimite,
          usuario: email
        );
          // Actualizar en la API
        final tareaConCambios = await _tareaService.actualizarTarea(taskId, tareaConEmail);
        
        // Actualizamos la caché local reemplazando solo la tarea modificada
        final nuevasTareas = tareasCacheadas.map((tarea) {
          return tarea.id == taskId ? tareaConCambios : tarea;
        }).toList();
        
        debugPrint('Tarea actualizada con ID: $taskId');
        
        await _cacheService.guardarTareas(nuevasTareas);
        await _cacheService.actualizarTimestamp();
        
        return tareaConCambios;
      },
      mensajeError: TareasConstantes.errorActualizar,
    );
  }
  
  /// Forzar la recarga de tareas desde la API
  Future<List<Tarea>> recargarTareas() async {
    return obtenerTareas(forzarRecarga: true);
  }
}