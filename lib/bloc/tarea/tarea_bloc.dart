import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_event.dart';
import 'package:vdenis/bloc/tarea/tarea_state.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:vdenis/data/tarea_repository.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:watch_it/watch_it.dart';

class TareaBloc extends Bloc<TareaEvent, TareaState> {
  final TareasRepository _tareaRepository = di<TareasRepository>();
  final SecureStorageService _secureStorage = di<SecureStorageService>();

  TareaBloc() : super(TareaInitial()) {
    on<TareaLoadEvent>(_onLoadTareas);
    on<TareaCreateEvent>(_onCreateTarea);
    on<TareaUpdateEvent>(_onUpdateTarea);
    on<TareaDeleteEvent>(_onDeleteTarea);
    on<TareaCompletadaEvent>(_onCompletadaTarea);
  }

  Future<void> _onLoadTareas(
    TareaLoadEvent event,
    Emitter<TareaState> emit,
  ) async {
    emit(TareaLoading());

    try {
      final tareas = await _tareaRepository.obtenerTareas(
        forzarRecarga: event.forzarRecarga,
      );

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

  Future<void> _onCreateTarea(
    TareaCreateEvent event,
    Emitter<TareaState> emit,
  ) async {
    final currentState = state;
    if (currentState is TareaLoaded) {
      try {
        final tareaConEmail = await _agregarEmailATarea(event.tarea);

        final nuevaTarea = await _tareaRepository.agregarTarea(tareaConEmail);
        final tareas = [...currentState.tareas, nuevaTarea];

        emit(
          TareaCreated(
            nuevaTarea: nuevaTarea,
            tareas: tareas,
            desdeCache: true,
            ultimaActualizacion: DateTime.now(),
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

        emit(currentState);
      }
    } else {
      add(TareaLoadEvent());
    }
  }

  Future<void> _onUpdateTarea(
    TareaUpdateEvent event,
    Emitter<TareaState> emit,
  ) async {
    final currentState = state;
    if (currentState is TareaLoaded) {
      try {
        final tareaActual = currentState.tareas.firstWhere(
          (t) => t.id == event.taskId,
        );

        final usuarioActual =
            tareaActual.usuario ??
            (await _secureStorage.getUserEmail() ?? 'usuario@anonimo.com');

        final tareaConEmail = event.tarea.copyWith(usuario: usuarioActual);

        final tareaActualizada = await _tareaRepository.actualizarTarea(
          tareaConEmail,
        );

        final tareas =
            currentState.tareas.map((tarea) {
              return tarea.id == event.taskId ? tareaActualizada : tarea;
            }).toList();
        emit(
          TareaUpdated(
            tareaActualizada: tareaActualizada,
            tareas: tareas,
            desdeCache: true,
            ultimaActualizacion: DateTime.now(),
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

        emit(currentState);
      }
    } else {
      add(TareaLoadEvent());
    }
  }

  Future<void> _onDeleteTarea(
    TareaDeleteEvent event,
    Emitter<TareaState> emit,
  ) async {
    final currentState = state;
    if (currentState is TareaLoaded) {
      try {
        await _tareaRepository.eliminarTarea(event.taskId);

        final tareas =
            currentState.tareas
                .where((tarea) => tarea.id != event.taskId)
                .toList();
        emit(
          TareaDeleted(
            tareaEliminadaId: event.taskId,
            tareas: tareas,
            desdeCache: true,
            ultimaActualizacion: DateTime.now(),
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

        emit(currentState);
      }
    } else {
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
      usuario: await _secureStorage.getUserEmail(),
      completada: tarea.completada,
    );
  }

  Future<void> _onCompletadaTarea(
    TareaCompletadaEvent event,
    Emitter<TareaState> emit,
  ) async {
    final currentState = state;
    if (currentState is TareaLoaded) {
      try {
        final tareaIndex = currentState.tareas.indexWhere(
          (t) => t.id == event.tareaId,
        );

        if (tareaIndex >= 0) {
          final tareaOriginal = currentState.tareas[tareaIndex];

          final tareaActualizada = tareaOriginal.copyWith(
            completada: event.completada,
          );

          await _tareaRepository.actualizarTareaEnCache(tareaActualizada);

          List<Tarea> nuevasTareas = List.from(currentState.tareas);
          nuevasTareas[tareaIndex] = tareaActualizada;

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

        emit(currentState);
      }
    }
  }
}
