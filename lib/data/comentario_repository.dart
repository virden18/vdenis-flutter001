import 'package:vdenis/api/service/comentario_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/comentario.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class ComentarioRepository extends BaseRepository<Comentario> {
  final _comentarioService = di<ComentarioService>();
  final _secureStorageService = di<SecureStorageService>();

  @override
  void validarEntidad(Comentario comentario) {
    validarNoVacio(comentario.texto, 'texto del comentario');
    validarNoVacio(comentario.autor, 'autor del comentario');
    validarNoVacio(comentario.noticiaId, 'ID de la noticia');
  }

  void validarSubcomentario(Comentario subcomentario) {
    validarEntidad(subcomentario);
  }

  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, 'ID de la noticia');
      final comentarios = await _comentarioService.obtenerComentariosPorNoticia(
        noticiaId,
      );
      return comentarios;
    }, mensajeError: 'Error al obtener comentarios');
  }

  Future<Comentario> agregarComentario(Comentario comentario) async {
    return manejarExcepcion(() async {
      validarEntidad(comentario);
      comentario = comentario.copyWith(
        autor: await _secureStorageService.getUserEmail(),
      );
      final response = await _comentarioService.agregarComentario(comentario);
      return response;
    }, mensajeError: 'Error al agregar comentario');
  }

  Future<Comentario> reaccionarComentario(
    String comentarioId,
    String tipo,
  ) async {
    return manejarExcepcion(() async {
      validarNoVacio(comentarioId, 'ID del comentario');
      Comentario response;
      if (comentarioId.contains('sub_')) {
        response = await _comentarioService.reaccionarSubComentario(
          subComentarioId: comentarioId,
          tipoReaccion: tipo,
        );
      } else {
        response = await _comentarioService.reaccionarComentarioPrincipal(
          comentarioId: comentarioId,
          tipoReaccion: tipo,
        );
      }
      return response;
    }, mensajeError: 'Error al registrar reacción');
  }

  Future<Comentario> agregarSubcomentario(Comentario subcomentario) async {
    return manejarExcepcion(() async {
      validarSubcomentario(subcomentario);
      final comentarioPadreId = subcomentario.idSubComentario!;

      subcomentario = subcomentario.copyWith(
        id:
            'sub_${DateTime.now().millisecondsSinceEpoch}_${subcomentario.texto.hashCode}',
        autor: await _secureStorageService.getUserEmail(),
      );

      final response = await _comentarioService.agregarSubcomentario(
        comentarioId: comentarioPadreId,
        subComentario: subcomentario,
      );
      return response;
    }, mensajeError: 'Error al agregar subcomentario');
  }
}
