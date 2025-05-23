import 'package:dart_mappable/dart_mappable.dart';
part 'tarea.mapper.dart';

@MappableClass()
class Tarea with TareaMappable{
  final String? id;
  final String titulo;
  final String tipo;
  final String? descripcion;
  final DateTime? fecha;
  final DateTime? fechaLimite; // Nueva fecha límite
  final List<String>? pasos; // Nuevos pasos

  Tarea({
    this.id,
    required this.titulo,
    this.tipo = 'normal', // Valor por defecto
    this.descripcion,
    this.fecha,
    this.fechaLimite,
    this.pasos,
  });
}