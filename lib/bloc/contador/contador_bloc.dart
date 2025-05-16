import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/contador/contador_event.dart';
import 'package:vdenis/bloc/contador/contador_state.dart';

class ContadorBloc extends Bloc<ContadorEvent, ContadorState> {
  ContadorBloc() : super(ContadorState(0)) {
    on<Incrementar>((event, emit) {
      emit(ContadorState(state.contador + 1));
    });

    on<Decrementar>((event, emit) {
      emit(ContadorState(state.contador - 1));
    });

    on<Resetear>((event, emit) {
      emit(ContadorState(0));
    });
  }
}