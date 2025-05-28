import 'package:vdenis/api/service/comentario_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/comentario.dart';
import 'package:vdenis/exceptions/api_exception.dart';

/// Repositorio para gestionar operaciones relacionadas con los comentarios.
/// Utiliza caché para mejorar la eficiencia al obtener comentarios.
class ComentarioRepository extends CacheableRepository<Comentario> {
  final ComentarioService _comentarioService = ComentarioService();
  
  // Caché por noticiaId para evitar recargar comentarios de la misma noticia
  final Map<String, List<Comentario>> _comentariosPorNoticia = {};
  
  // Noticia actualmente seleccionada para mostrar comentarios
  String? _noticiaSeleccionadaId;
  
  @override
  void validarEntidad(Comentario comentario) {
    validarNoVacio(comentario.texto, 'texto del comentario');
    validarNoVacio(comentario.autor, 'autor del comentario');
    validarNoVacio(comentario.noticiaId, 'ID de la noticia');
  }
  
  /// Implementación requerida por CacheableRepository
  /// En este caso, carga todos los comentarios de la noticia actual
  @override
  Future<List<Comentario>> cargarDatos() async {
    // Si no hay noticia seleccionada, devolvemos una lista vacía
    if (_noticiaSeleccionadaId == null) return [];
    
    // Obtenemos los comentarios de la noticia actual
    final comentarios = await _comentarioService.obtenerComentariosPorNoticia(_noticiaSeleccionadaId!);
    
    // Almacenamos en la caché por noticia
    _comentariosPorNoticia[_noticiaSeleccionadaId!] = comentarios;
    
    return comentarios;
  }
  
  /// Método para validar un subcomentario
  void validarSubcomentario(Comentario subcomentario) {
    // Primero validamos como comentario normal
    validarEntidad(subcomentario);
    
    if (subcomentario.idSubComentario == null || subcomentario.idSubComentario!.isEmpty) {
      throw ApiException('El ID del comentario padre no puede estar vacío.', statusCode: 400);
    }
    if (!subcomentario.isSubComentario) {
      throw ApiException('El comentario debe marcarse como subcomentario.', statusCode: 400);
    }
  }
  
  /// Establece la noticia actual y carga sus comentarios
  Future<void> establecerNoticiaActual(String noticiaId) async {
    validarNoVacio(noticiaId, 'ID de la noticia');
    _noticiaSeleccionadaId = noticiaId;
  }

  /// Obtiene todos los comentarios de una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, 'ID de la noticia');
      
      if (_comentariosPorNoticia.containsKey(noticiaId)) {
        return _comentariosPorNoticia[noticiaId]!;
      }
    
      if (noticiaId == _noticiaSeleccionadaId) {
        return await obtenerDatos(forzarRecarga: true);
      }
     
      final comentarios = await _comentarioService.obtenerComentariosPorNoticia(noticiaId);
      _comentariosPorNoticia[noticiaId] = comentarios;
      return comentarios;
    }, mensajeError: 'Error al obtener comentarios');
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(Comentario comentario) async {
    return manejarExcepcion(() async {
      validarEntidad(comentario);
      await _comentarioService.agregarComentario(comentario);
      
      // Invalidar caché para la noticia correspondiente
      _comentariosPorNoticia.remove(comentario.noticiaId);
      invalidarCache();
    }, mensajeError: 'Error al agregar comentario');
  }

  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    return manejarExcepcion(() {
      validarNoVacio(noticiaId, 'ID de la noticia');
      return _comentarioService.obtenerNumeroComentarios(noticiaId);
    }, mensajeError: 'Error al obtener número de comentarios');
  }  

  /// Registra una reacción (like o dislike) a un comentario
  Future<Comentario> reaccionarComentario({
    required String comentarioId, 
    required String tipoReaccion, 
  }) async {
    return manejarExcepcion(() async {
      validarNoVacio(comentarioId, 'ID del comentario');

      if (tipoReaccion != 'like' && tipoReaccion != 'dislike') {
        throw ApiException(
          'El tipo de reacción debe ser "like" o "dislike".',
          statusCode: 400,
        );
      }
      
      try {
        // Realizar la llamada a la API para registrar la reacción
        final response = await _comentarioService.reaccionarComentario(
          comentarioId: comentarioId, 
          tipoReaccion: tipoReaccion  
        );
        
        invalidarCache();
        return response;
      } catch (e) {
        rethrow;
      }
    }, mensajeError: 'Error al registrar reacción');
  }

  /// Agrega un subcomentario a un comentario existente
  /// Los subcomentarios no pueden tener a su vez subcomentarios
  Future<void> agregarSubcomentario(Comentario subcomentario) async {
    return manejarExcepcion(() async {
      validarSubcomentario(subcomentario);
      
      // El idSubComentario contiene el ID del comentario padre al que queremos responder
      final comentarioPadreId = subcomentario.idSubComentario!;
      
      await _comentarioService.agregarSubcomentario(
        comentarioId: comentarioPadreId, 
        autor: subcomentario.autor, 
        texto: subcomentario.texto
      );
      
      // Invalidar caché para la noticia correspondiente
      _comentariosPorNoticia.remove(subcomentario.noticiaId);
      invalidarCache();
    }, mensajeError: 'Error al agregar subcomentario');
  }
  
  /// Invalida toda la caché de comentarios
  @override
  void invalidarCache() {
    super.invalidarCache();
    _comentariosPorNoticia.clear();
  }
}
