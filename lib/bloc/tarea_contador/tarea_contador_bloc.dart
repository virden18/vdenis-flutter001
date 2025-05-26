import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:vdenis/bloc/tarea_contador/tarea_contador_state.dart';

/// BLoC para manejar el conteo de tareas
class TareaContadorBloc extends Bloc<TareaContadorEvent, TareaContadorState> {
  TareaContadorBloc() : super(const TareaContadorState()) {
    on<IncrementarContador>(_onIncrementarContador);
    on<DecrementarContador>(_onDecrementarContador);
    on<SetTotalTareas>(_onSetTotalTareas);
    on<SetTareasCompletadas>(_onSetTareasCompletadas);
  }

  /// Maneja el evento para incrementar el contador de tareas completadas
  void _onIncrementarContador(
    IncrementarContador event,
    Emitter<TareaContadorState> emit,
  ) {
    // Incrementamos tareas completadas y actualizamos pendientes
    final tareasCompletadas = state.tareasCompletadas + 1;
    final tareasPendientes = state.totalTareas - tareasCompletadas;
    
    emit(state.copyWith(
      tareasCompletadas: tareasCompletadas > state.totalTareas ? state.totalTareas : tareasCompletadas,
      tareasPendientes: tareasPendientes >= 0 ? tareasPendientes : 0,
    ));
  }

  /// Maneja el evento para decrementar el contador de tareas completadas
  void _onDecrementarContador(
    DecrementarContador event,
    Emitter<TareaContadorState> emit,
  ) {
    // Decrementamos tareas completadas y actualizamos pendientes
    final tareasCompletadas = state.tareasCompletadas - 1;
    final tareasPendientes = state.totalTareas - tareasCompletadas;
    
    emit(state.copyWith(
      tareasCompletadas: tareasCompletadas >= 0 ? tareasCompletadas : 0,
      tareasPendientes: tareasPendientes <= state.totalTareas ? tareasPendientes : state.totalTareas,
    ));
  }

  /// Maneja el evento para establecer el total de tareas
  void _onSetTotalTareas(
    SetTotalTareas event,
    Emitter<TareaContadorState> emit,
  ) {
    // Actualizamos el total y recalculamos las pendientes
    final totalTareas = event.total;
    final tareasPendientes = totalTareas - state.tareasCompletadas;
    
    emit(state.copyWith(
      totalTareas: totalTareas,
      tareasPendientes: tareasPendientes >= 0 ? tareasPendientes : 0,
    ));
  }
  
  /// Maneja el evento para establecer directamente el número de tareas completadas
  void _onSetTareasCompletadas(
    SetTareasCompletadas event,
    Emitter<TareaContadorState> emit,
  ) {
    // Establecemos el número exacto de tareas completadas y recalculamos pendientes
    final tareasCompletadas = event.completadas <= state.totalTareas 
        ? event.completadas 
        : state.totalTareas;
    final tareasPendientes = state.totalTareas - tareasCompletadas;
    
    emit(state.copyWith(
      tareasCompletadas: tareasCompletadas,
      tareasPendientes: tareasPendientes >= 0 ? tareasPendientes : 0,
    ));
  }
}