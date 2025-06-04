import 'package:equatable/equatable.dart';

abstract class TareaContadorEvent extends Equatable {
  const TareaContadorEvent();

  @override
  List<Object?> get props => [];
}

class IncrementarContador extends TareaContadorEvent {
  const IncrementarContador();
}

class DecrementarContador extends TareaContadorEvent {
  const DecrementarContador();
}

class SetTotalTareas extends TareaContadorEvent {
  final int total;

  const SetTotalTareas(this.total);

  @override
  List<Object?> get props => [total];
}

class SetTareasCompletadas extends TareaContadorEvent {
  final int completadas;

  const SetTareasCompletadas(this.completadas);

  @override
  List<Object?> get props => [completadas];
}
