import 'package:equatable/equatable.dart';
import 'package:vdenis/exceptions/api_exception.dart';

abstract class PreferenciaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PreferenciaInitial extends PreferenciaState {}

class PreferenciaLoading extends PreferenciaState {}

enum TipoOperacionPreferencia { cargar, guardar, reiniciar, cambiarCategoria }

class PreferenciaError extends PreferenciaState {
  final String mensaje;
  final ApiException error;
  final TipoOperacionPreferencia tipoOperacion;

  PreferenciaError(
    this.mensaje, {
    required this.error,
    this.tipoOperacion = TipoOperacionPreferencia.cargar,
  });

  @override
  List<Object?> get props => [mensaje, error, tipoOperacion];
}

class PreferenciasLoaded extends PreferenciaState {
  final List<String> categoriasSeleccionadas;
  final DateTime? lastUpdated;
  final bool operacionExitosa;

  PreferenciasLoaded({
    this.categoriasSeleccionadas = const [],
    this.lastUpdated,
    this.operacionExitosa = false,
  });

  @override
  List<Object?> get props => [
    categoriasSeleccionadas,
    lastUpdated,
    operacionExitosa,
  ];
}

class PreferenciasSaved extends PreferenciasLoaded {
  PreferenciasSaved({
    required super.categoriasSeleccionadas,
    super.lastUpdated,
    super.operacionExitosa = true,
  });
}

class PreferenciasReset extends PreferenciasLoaded {
  PreferenciasReset({
    super.categoriasSeleccionadas = const [],
    super.lastUpdated,
    super.operacionExitosa = true,
  });
}
