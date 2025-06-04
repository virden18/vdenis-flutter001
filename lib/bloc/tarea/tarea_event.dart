import 'package:equatable/equatable.dart';
import 'package:vdenis/domain/tarea.dart';

abstract class TareaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TareaLoadEvent extends TareaEvent {
  final int limite;
  final bool forzarRecarga;

  TareaLoadEvent({this.limite = 5, this.forzarRecarga = false});

  @override
  List<Object?> get props => [limite, forzarRecarga];
}

class TareaCreateEvent extends TareaEvent {
  final Tarea tarea;

  TareaCreateEvent(this.tarea);

  @override
  List<Object?> get props => [tarea];
}

class TareaUpdateEvent extends TareaEvent {
  final String taskId;
  final Tarea tarea;

  TareaUpdateEvent({required this.taskId, required this.tarea});

  @override
  List<Object?> get props => [taskId, tarea];
}

class TareaDeleteEvent extends TareaEvent {
  final String taskId;

  TareaDeleteEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class TareaCompletadaEvent extends TareaEvent {
  final String tareaId;
  final bool completada;

  TareaCompletadaEvent({required this.tareaId, required this.completada});

  @override
  List<Object?> get props => [tareaId, completada];
}
