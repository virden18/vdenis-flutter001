import 'package:equatable/equatable.dart';

/// Estado para el contador de tareas
class TareaContadorState extends Equatable {
  final int totalTareas;
  final int tareasCompletadas;
  final int tareasPendientes;

  const TareaContadorState({
    this.totalTareas = 0,
    this.tareasCompletadas = 0,
    this.tareasPendientes = 0,
  });

  /// Crea una copia del estado con los valores actualizados
  TareaContadorState copyWith({
    int? totalTareas,
    int? tareasCompletadas,
    int? tareasPendientes,
  }) {
    return TareaContadorState(
      totalTareas: totalTareas ?? this.totalTareas,
      tareasCompletadas: tareasCompletadas ?? this.tareasCompletadas,
      tareasPendientes: tareasPendientes ?? this.tareasPendientes,
    );
  }

  @override
  List<Object?> get props => [totalTareas, tareasCompletadas, tareasPendientes];
}