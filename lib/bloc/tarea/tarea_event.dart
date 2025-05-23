import 'package:equatable/equatable.dart';
import 'package:vdenis/domain/task.dart';

abstract class TareaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Evento para cargar las tareas iniciales
class TareaLoadEvent extends TareaEvent {
  final int limite;
  
  TareaLoadEvent({
    this.limite = 5,
  });
  
  @override
  List<Object?> get props => [limite];
}

/// Evento para cargar más tareas (paginación)
class TareaLoadMoreEvent extends TareaEvent {
  final int inicio;
  final int limite;
  
  TareaLoadMoreEvent({
    required this.inicio,
    this.limite = 5
  });
  
  @override
  List<Object?> get props => [inicio, limite];
}

/// Evento para crear una nueva tarea
class TareaCreateEvent extends TareaEvent {
  final Task tarea;

  TareaCreateEvent(this.tarea);

  @override
  List<Object?> get props => [tarea];
}

/// Evento para actualizar una tarea existente
class TareaUpdateEvent extends TareaEvent {
  final String taskId;
  final Task tarea;

  TareaUpdateEvent({
    required this.taskId, 
    required this.tarea
  });

  @override
  List<Object?> get props => [taskId, tarea];
}

/// Evento para eliminar una tarea
class TareaDeleteEvent extends TareaEvent {
  final String taskId;

  TareaDeleteEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
