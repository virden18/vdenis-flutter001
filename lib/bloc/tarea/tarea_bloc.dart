import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_event.dart';
import 'package:vdenis/bloc/tarea/tarea_state.dart';
import 'package:vdenis/data/auth_repository.dart';
import 'package:vdenis/data/tarea_repository.dart';
import 'package:vdenis/domain/tarea.dart'; // Importamos la clase Tarea
import 'package:watch_it/watch_it.dart';

class TareaBloc extends Bloc<TareaEvent, TareaState> {
  final TareasRepository _tareaRepository = di<TareasRepository>();
  final AuthRepository _authRepository = di<AuthRepository>();

  TareaBloc() : super(TareaInitial()) {
    on<TareaLoadEvent>(_onLoadTareas);
    on<TareaCreateEvent>(_onCreateTarea);
    on<TareaUpdateEvent>(_onUpdateTarea);
    on<TareaDeleteEvent>(_onDeleteTarea);
    on<TareaCompletadaEvent>(_onCompletadaTarea);
  }

  /// Maneja el evento para cargar tareas iniciales
  Future<void> _onLoadTareas(
    TareaLoadEvent event,
    Emitter<TareaState> emit,
  ) async {
    // Emitimos estado de carga
    emit(TareaLoading());

    try {
      // Obtenemos las tareas del repositorio usando el flag para forzar recarga si es necesario
      final tareas = await _tareaRepository.obtenerTareas(
        forzarRecarga: event.forzarRecarga,
      );

      // Emitimos el estado con las tareas cargadas
      emit(
        TareaLoaded(
          tareas: tareas,
          desdeCache: !event.forzarRecarga,
          ultimaActualizacion: DateTime.now(),
        ),
      );
    } catch (e) {
      debugPrint('Error en _onLoadTareas: $e');
      emit(
        TareaError(
          e is Exception ? e : Exception(e.toString()),
          TipoOperacionTarea.cargar,
        ),
      );
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
        // Creamos una copia de la tarea con el email del usuario
        final tareaConEmail = await _agregarEmailATarea(event.tarea);

        // Creamos la nueva tarea
        final nuevaTarea = await _tareaRepository.agregarTarea(
          tareaConEmail,
        ); // Añadimos la nueva tarea al inicio de la lista (no al final)
        final tareas = [ ...currentState.tareas, nuevaTarea];

        // Emitimos el estado de tarea creada
        emit(
          TareaCreated(
            nuevaTarea: nuevaTarea,
            tareas: tareas,
            desdeCache: true, // Indicamos que viene de la caché
            ultimaActualizacion: DateTime.now(), // Actualizamos la fecha
          ),
        );
      } catch (e) {
        debugPrint('Error en _onCreateTarea: $e');
        emit(
          TareaError(
            e is Exception ? e : Exception(e.toString()),
            TipoOperacionTarea.crear,
          ),
        );

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
        // Buscamos la tarea actual para obtener el email
        final tareaActual = currentState.tareas.firstWhere(
          (t) => t.id == event.taskId,
        );

        // Aseguramos que se mantenga el email original o conseguimos uno nuevo
        final usuarioActual =
            tareaActual.usuario ??
            (await _authRepository.getUserEmail() ?? 'usuario@anonimo.com');

        // Creamos una versión actualizada preservando el email
        final tareaConEmail = event.tarea.copyWith(usuario: usuarioActual);

        // Actualizamos la tarea
        final tareaActualizada = await _tareaRepository.actualizarTarea(
          tareaConEmail,
        );

        // Reemplazamos la tarea actualizada en la lista
        final tareas =
            currentState.tareas.map((tarea) {
              return tarea.id == event.taskId ? tareaActualizada : tarea;
            }).toList(); // Emitimos el estado de tarea actualizada
        emit(
          TareaUpdated(
            tareaActualizada: tareaActualizada,
            tareas: tareas,
            desdeCache: true, // Indicamos que viene de la caché
            ultimaActualizacion: DateTime.now(), // Actualizamos la fecha
          ),
        );
      } catch (e) {
        debugPrint('Error en _onUpdateTarea: $e');
        emit(
          TareaError(
            e is Exception ? e : Exception(e.toString()),
            TipoOperacionTarea.actualizar,
          ),
        );

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
        final tareas =
            currentState.tareas
                .where((tarea) => tarea.id != event.taskId)
                .toList(); // Emitimos el estado de tarea eliminada
        emit(
          TareaDeleted(
            tareaEliminadaId: event.taskId,
            tareas: tareas,
            desdeCache: true, // Indicamos que viene de la caché
            ultimaActualizacion: DateTime.now(), // Actualizamos la fecha
          ),
        );
      } catch (e) {
        debugPrint('Error en _onDeleteTarea: $e');
        emit(
          TareaError(
            e is Exception ? e : Exception(e.toString()),
            TipoOperacionTarea.eliminar,
          ),
        );

        // Restauramos el estado anterior después del error
        emit(currentState);
      }
    } else {
      // Si no hay tareas cargadas aún, primero cargamos las tareas
      add(TareaLoadEvent());
    }
  }

  Future<Tarea> _agregarEmailATarea(Tarea tarea) async {
    return Tarea(
      id: tarea.id,
      titulo: tarea.titulo,
      tipo: tarea.tipo,
      descripcion: tarea.descripcion,
      fecha: tarea.fecha,
      fechaLimite: tarea.fechaLimite,
      usuario: await _authRepository.getUserEmail(),
      completada: tarea.completada,
    );
  }

  Future<void> _onCompletadaTarea(
    TareaCompletadaEvent event,
    Emitter<TareaState> emit,
  ) async {
    // Guardamos el estado actual para preservar las tareas ya cargadas
    final currentState = state;
    if (currentState is TareaLoaded) {
      try {
        // Buscamos la tarea que queremos marcar
        final tareaIndex = currentState.tareas.indexWhere(
          (t) => t.id == event.tareaId,
        );
        
        if (tareaIndex >= 0) {
          final tareaOriginal = currentState.tareas[tareaIndex];
          
          final tareaActualizada = tareaOriginal.copyWith(
            completada: event.completada,
          );
          
          // Actualizamos la caché directamente sin llamar a la API
          await _tareaRepository.actualizarTareaEnCache(tareaActualizada);
          
          // Actualizamos la lista de tareas en memoria
          List<Tarea> nuevasTareas = List.from(currentState.tareas);
          nuevasTareas[tareaIndex] = tareaActualizada;
          
          // Emitimos el estado actualizado
          emit(
            TareaCompletada(
              tareaId: event.tareaId,
              completada: event.completada,
              tareas: nuevasTareas,
              desdeCache: true,
              ultimaActualizacion: DateTime.now(),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error en _onCompletarTarea: $e');
        emit(
          TareaError(
            e is Exception ? e : Exception(e.toString()),
            TipoOperacionTarea.completar,
          ),
        );
        
        // Restauramos el estado anterior después del error
        emit(currentState);
      }
    }
  }
}
