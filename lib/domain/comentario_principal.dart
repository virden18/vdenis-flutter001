
import 'package:dart_mappable/dart_mappable.dart';
import 'package:vdenis/domain/comentario.dart';

//part 'comentario_principal.mapper.dart';

@MappableClass()
class ComentarioPrincipal extends Comentario {
  @MappableField()
  ComentarioPrincipal({
    super.subcomentarios,
    required super.noticiaId,
    required super.texto,
    required super.fecha,
    required super.autor,
    required super.likes,
    required super.dislikes
    });
}