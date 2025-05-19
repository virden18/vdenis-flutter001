import 'package:vdenis/api/service/comentario_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/comentario.dart';

class ComentarioRepository extends BaseRepository {
  final ComentariosService _service = ComentariosService();

  /// Obtiene los comentarios asociados a una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');
    
    return executeServiceCall(
      serviceCall: () => _service.obtenerComentariosPorNoticia(noticiaId),
      operacion: 'obtener comentarios para noticia $noticiaId',
    );
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');


    return executeServiceCall(
      serviceCall: () => _service.agregarComentario(noticiaId, texto, autor, fecha),
      operacion: 'agregar comentario a noticia $noticiaId',
    );
  }

  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');
    
    return executeServiceCall(
      serviceCall: () => _service.obtenerNumeroComentarios(noticiaId),
      operacion: 'obtener número de comentarios para noticia $noticiaId',
    );
  }

  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    validateId(comentarioId, mensaje: 'ID de comentario no válido');
    
    return executeServiceCall(
      serviceCall: () => _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      ),
      operacion: 'reaccionar a comentario $comentarioId',
    );
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    validateId(comentarioId, mensaje: 'ID de comentario no válido');
    
    if (texto.isEmpty) {
      return {
        'success': false,
        'message': 'El texto del subcomentario no puede estar vacío.',
      };
    }

    return executeServiceCall(
      serviceCall: () => _service.agregarSubcomentario(
        comentarioId: comentarioId,
        texto: texto,
        autor: autor,
      ),
      operacion: 'agregar subcomentario a comentario $comentarioId',
    );
  }
}
