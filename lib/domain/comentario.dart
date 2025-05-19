import 'package:dart_mappable/dart_mappable.dart';
part 'comentario.mapper.dart';

@MappableClass()
class Comentario with ComentarioMappable {
  final String? id; // Cambiado a nullable
  final String noticiaId;//
  final String texto;//
  final String fecha;//
  final String autor;//
  final int likes;//
  final int dislikes;//
  final List<Comentario>? subcomentarios;
  final bool isSubComentario; // Ahora es required con valor por defecto
  final String? idSubComentario;

  Comentario({
    this.id, // id ahora es opcional
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
    this.subcomentarios,
    this.isSubComentario = false, // Valor por defecto
    this.idSubComentario, // idSubComentario es opcional
  });
}
