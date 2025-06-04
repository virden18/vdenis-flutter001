import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:vdenis/bloc/tarea_contador/tarea_contador_state.dart';

class TareaContadorBloc extends Bloc<TareaContadorEvent, TareaContadorState> {
  TareaContadorBloc() : super(const TareaContadorState()) {
    on<IncrementarContador>(_onIncrementarContador);
    on<DecrementarContador>(_onDecrementarContador);
    on<SetTotalTareas>(_onSetTotalTareas);
    on<SetTareasCompletadas>(_onSetTareasCompletadas);
  }

  void _onIncrementarContador(
    IncrementarContador event,
    Emitter<TareaContadorState> emit,
  ) {
    final tareasCompletadas = state.tareasCompletadas + 1;
    final tareasPendientes = state.totalTareas - tareasCompletadas;

    emit(
      state.copyWith(
        tareasCompletadas:
            tareasCompletadas > state.totalTareas
                ? state.totalTareas
                : tareasCompletadas,
        tareasPendientes: tareasPendientes >= 0 ? tareasPendientes : 0,
      ),
    );
  }

  void _onDecrementarContador(
    DecrementarContador event,
    Emitter<TareaContadorState> emit,
  ) {
    final tareasCompletadas = state.tareasCompletadas - 1;
    final tareasPendientes = state.totalTareas - tareasCompletadas;

    emit(
      state.copyWith(
        tareasCompletadas: tareasCompletadas >= 0 ? tareasCompletadas : 0,
        tareasPendientes:
            tareasPendientes <= state.totalTareas
                ? tareasPendientes
                : state.totalTareas,
      ),
    );
  }

  void _onSetTotalTareas(
    SetTotalTareas event,
    Emitter<TareaContadorState> emit,
  ) {
    final totalTareas = event.total;
    final tareasPendientes = totalTareas - state.tareasCompletadas;

    emit(
      state.copyWith(
        totalTareas: totalTareas,
        tareasPendientes: tareasPendientes >= 0 ? tareasPendientes : 0,
      ),
    );
  }

  void _onSetTareasCompletadas(
    SetTareasCompletadas event,
    Emitter<TareaContadorState> emit,
  ) {
    final tareasCompletadas =
        event.completadas <= state.totalTareas
            ? event.completadas
            : state.totalTareas;
    final tareasPendientes = state.totalTareas - tareasCompletadas;

    emit(
      state.copyWith(
        tareasCompletadas: tareasCompletadas,
        tareasPendientes: tareasPendientes >= 0 ? tareasPendientes : 0,
      ),
    );
  }
}
