import 'package:equatable/equatable.dart';

abstract class PreferenciaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPreferences extends PreferenciaEvent {
  LoadPreferences();
}

class SavePreferences extends PreferenciaEvent {
  final List<String> selectedCategories;

  SavePreferences({required this.selectedCategories});

  @override
  List<Object?> get props => [selectedCategories];
}

class ChangeCategory extends PreferenciaEvent {
  final String category;
  final bool selected;

  ChangeCategory({required this.category, required this.selected});

  @override
  List<Object?> get props => [category, selected];
}

class ResetFilters extends PreferenciaEvent {
  ResetFilters();
}
