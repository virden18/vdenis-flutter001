import 'package:equatable/equatable.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/exceptions/api_exception.dart';

abstract class TareaState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Estado inicial cuando aún no se ha cargado ninguna tarea
class TareaInitial extends TareaState {}

/// Tipo de operación para manejar errores específicos
enum TipoOperacionTarea { cargar, crear, actualizar, eliminar, completar }

/// Estado de error para cualquier operación de tareas
class TareaError extends TareaState {
  final Exception error;
  final TipoOperacionTarea tipoOperacion;

  TareaError(this.error, this.tipoOperacion);

  @override
  List<Object?> get props => [error, tipoOperacion];
  /// Método para obtener un mensaje de error amigable según el tipo de operación
  String get mensaje {
    final base = error is ApiException 
        ? (error as ApiException)
        : error.toString();
          switch (tipoOperacion) {
      case TipoOperacionTarea.cargar:
        return 'Error al cargar las tareas: $base';
      case TipoOperacionTarea.crear:
        return 'Error al crear la tarea: $base';
      case TipoOperacionTarea.actualizar:
        return 'Error al actualizar la tarea: $base';
      case TipoOperacionTarea.eliminar:
        return 'Error al eliminar la tarea: $base';
      case TipoOperacionTarea.completar:
        return 'Error al cambiar el estado de la tarea: $base';
    }
  }
}

/// Estado de carga para cualquier operación
class TareaLoading extends TareaState {
  final bool isInitialLoad;
  
  TareaLoading({this.isInitialLoad = true});
  
  @override
  List<Object?> get props => [isInitialLoad];
}

// Se eliminó la clase TareaLoadingMore que se usaba para paginación

/// Estado base para cuando se han cargado las tareas
class TareaLoaded extends TareaState {
  final List<Tarea> tareas;
  final bool desdeCache;
  final DateTime? ultimaActualizacion;

  TareaLoaded({
    required this.tareas,
    this.desdeCache = false,
    this.ultimaActualizacion,
  });

  @override
  List<Object?> get props => [tareas, desdeCache, ultimaActualizacion];
  
  /// Factory para crear una copia con nuevos valores
  TareaLoaded copyWith({
    List<Tarea>? tareas,
    bool? desdeCache,
    DateTime? ultimaActualizacion,
  }) {
    return TareaLoaded(
      tareas: tareas ?? this.tareas,
      desdeCache: desdeCache ?? this.desdeCache,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
    );
  }
}

/// Estado para cuando se ha creado una nueva tarea
class TareaCreated extends TareaLoaded {
  final Tarea nuevaTarea;

  TareaCreated({
    required this.nuevaTarea,
    required super.tareas,
    super.desdeCache = false,
    super.ultimaActualizacion,
  });

  @override
  List<Object?> get props => [nuevaTarea, ...super.props];
}

/// Estado para cuando se ha actualizado una tarea
class TareaUpdated extends TareaLoaded {
  final Tarea tareaActualizada;

  TareaUpdated({
    required this.tareaActualizada,
    required super.tareas,
    super.desdeCache = false,
    super.ultimaActualizacion,
  });

  @override
  List<Object?> get props => [tareaActualizada, ...super.props];
}

/// Estado para cuando se ha eliminado una tarea
class TareaDeleted extends TareaLoaded {
  final String tareaEliminadaId;

  TareaDeleted({
    required this.tareaEliminadaId,
    required super.tareas,
    super.desdeCache = false,
    super.ultimaActualizacion,
  });

  @override
  List<Object?> get props => [tareaEliminadaId, ...super.props];
}

/// Estado para cuando se ha marcado una tarea como completada o no completada
class TareaCompletada extends TareaLoaded {
  final String tareaId;
  final bool completada;

  TareaCompletada({
    required this.tareaId,
    required this.completada,
    required super.tareas,
    super.desdeCache = false,
    super.ultimaActualizacion,
  });

  @override
  List<Object?> get props => [tareaId, completada, ...super.props];
}
