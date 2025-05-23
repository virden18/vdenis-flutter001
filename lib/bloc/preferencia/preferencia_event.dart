import 'package:equatable/equatable.dart';

abstract class PreferenciaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento para cargar las preferencias iniciales
class LoadPreferences extends PreferenciaEvent {
  LoadPreferences();
}

// Evento para guardar las preferencias
class SavePreferences extends PreferenciaEvent {
  final List<String> selectedCategories;

  SavePreferences({required this.selectedCategories});

  @override
  List<Object?> get props => [selectedCategories];
}

// Evento para cambiar la selección de una categoría
class ChangeCategory extends PreferenciaEvent {
  final String category;
  final bool selected;

  ChangeCategory({required this.category, required this.selected});

  @override
  List<Object?> get props => [category, selected];
}

// Evento para restablecer todos los filtros
class ResetFilters extends PreferenciaEvent {
  ResetFilters();
}
