import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_event.dart';
import 'package:vdenis/bloc/tarea/tarea_state.dart';
import 'package:vdenis/data/tarea_repository.dart';

class TareaBloc extends Bloc<TareaEvent, TareaState> {
  final TareasRepository _tareaRepository = TareasRepository();
  
  TareaBloc() : super(TareaInitial()) {
    on<TareaLoadEvent>(_onLoadTareas);
    on<TareaCreateEvent>(_onCreateTarea);
    on<TareaUpdateEvent>(_onUpdateTarea);
    on<TareaDeleteEvent>(_onDeleteTarea);
  }
  /// Maneja el evento para cargar tareas iniciales
  Future<void> _onLoadTareas(
    TareaLoadEvent event,
    Emitter<TareaState> emit,
  ) async {
    // Emitimos estado de carga
    emit(TareaLoading());
    
    try {
      // Obtenemos las tareas del repositorio
      final tareas = await _tareaRepository.obtenerTareas(
        limite: event.limite,
      );
      
      // Emitimos el estado con las tareas cargadas
      emit(TareaLoaded(
        tareas: tareas,
        hayMasTareas: tareas.length >= event.limite, // Si obtenemos el límite completo, asumimos que hay más
      ));
    } catch (e) {
      debugPrint('Error en _onLoadTareas: $e');
      emit(TareaError(
        e is Exception ? e : Exception(e.toString()),
        TipoOperacionTarea.cargar,
      ));
    }
  }

  /// Maneja el evento para crear una nueva tarea
  Future<void> _onCreateTarea(
    TareaCreateEvent event,
    Emitter<TareaState> emit,
  ) async {
    // Guardamos el estado actual para preservar las tareas ya cargadas
    final currentState = state;
    if (currentState is TareaLoaded) {
      try {
        // Creamos la nueva tarea
        final nuevaTarea = await _tareaRepository.agregarTarea(event.tarea);
        
        // Añadimos la nueva tarea al inicio de la lista
        final tareas = [nuevaTarea, ...currentState.tareas];
        
        // Emitimos el estado de tarea creada
        emit(TareaCreated(
          nuevaTarea: nuevaTarea,
          tareas: tareas,
          hayMasTareas: currentState.hayMasTareas,
        ));
      } catch (e) {
        debugPrint('Error en _onCreateTarea: $e');
        emit(TareaError(
          e is Exception ? e : Exception(e.toString()),
          TipoOperacionTarea.crear,
        ));
        
        // Restauramos el estado anterior después del error
        emit(currentState);
      }
    } else {
      // Si no hay tareas cargadas aún, primero cargamos las tareas
      add(TareaLoadEvent());
    }
  }

  /// Maneja el evento para actualizar una tarea existente
  Future<void> _onUpdateTarea(
    TareaUpdateEvent event,
    Emitter<TareaState> emit,
  ) async {
    // Guardamos el estado actual para preservar las tareas ya cargadas
    final currentState = state;
    if (currentState is TareaLoaded) {
      try {
        // Actualizamos la tarea
        final tareaActualizada = await _tareaRepository.actualizarTarea(
          event.taskId,
          event.tarea,
        );
        
        // Reemplazamos la tarea actualizada en la lista
        final tareas = currentState.tareas.map((tarea) {
          return tarea.id == event.taskId ? tareaActualizada : tarea;
        }).toList();
        
        // Emitimos el estado de tarea actualizada
        emit(TareaUpdated(
          tareaActualizada: tareaActualizada,
          tareas: tareas,
          hayMasTareas: currentState.hayMasTareas,
        ));
      } catch (e) {
        debugPrint('Error en _onUpdateTarea: $e');
        emit(TareaError(
          e is Exception ? e : Exception(e.toString()),
          TipoOperacionTarea.actualizar,
        ));
        
        // Restauramos el estado anterior después del error
        emit(currentState);
      }
    } else {
      // Si no hay tareas cargadas aún, primero cargamos las tareas
      add(TareaLoadEvent());
    }
  }

  /// Maneja el evento para eliminar una tarea
  Future<void> _onDeleteTarea(
    TareaDeleteEvent event,
    Emitter<TareaState> emit,
  ) async {
    // Guardamos el estado actual para preservar las tareas ya cargadas
    final currentState = state;
    if (currentState is TareaLoaded) {
      try {
        // Eliminamos la tarea
        await _tareaRepository.eliminarTarea(event.taskId);
        
        // Filtramos la tarea eliminada de la lista
        final tareas = currentState.tareas
            .where((tarea) => tarea.id != event.taskId)
            .toList();
        
        // Emitimos el estado de tarea eliminada
        emit(TareaDeleted(
          tareaEliminadaId: event.taskId,
          tareas: tareas,
          hayMasTareas: currentState.hayMasTareas,
        ));
      } catch (e) {
        debugPrint('Error en _onDeleteTarea: $e');
        emit(TareaError(
          e is Exception ? e : Exception(e.toString()),
          TipoOperacionTarea.eliminar,
        ));
        
        // Restauramos el estado anterior después del error
        emit(currentState);
      }
    } else {
      // Si no hay tareas cargadas aún, primero cargamos las tareas
      add(TareaLoadEvent());
    }
  }
}
