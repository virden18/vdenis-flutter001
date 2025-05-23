import 'package:dart_mappable/dart_mappable.dart';
part 'categoria.mapper.dart';

@MappableClass()
class Categoria with CategoriaMappable {
  final String? id; // ID asignado por la API (opcional, para operaciones CRUD)
  final String nombre; 
  final String descripcion; 
  final String imagenUrl; 

  Categoria({
    this.id, // Puede ser null al crear una categoría, se asigna al guardarla
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
  });
}
