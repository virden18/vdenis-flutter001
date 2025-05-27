import 'package:equatable/equatable.dart';

/// Eventos base para el contador de tareas
abstract class TareaContadorEvent extends Equatable {
  const TareaContadorEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para incrementar el contador de tareas completadas
class IncrementarContador extends TareaContadorEvent {
  const IncrementarContador();
}

/// Evento para decrementar el contador de tareas completadas
class DecrementarContador extends TareaContadorEvent {
  const DecrementarContador();
}

/// Evento para establecer el total de tareas
class SetTotalTareas extends TareaContadorEvent {
  final int total;

  const SetTotalTareas(this.total);

  @override
  List<Object?> get props => [total];
}

/// Evento para establecer el número de tareas completadas
class SetTareasCompletadas extends TareaContadorEvent {
  final int completadas;

  const SetTareasCompletadas(this.completadas);

  @override
  List<Object?> get props => [completadas];
}