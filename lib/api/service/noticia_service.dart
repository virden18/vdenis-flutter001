import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/error_helper.dart';

class NoticiaService {
  final NoticiaRepository _repository = NoticiaRepository();

  /// Carga noticias desde el repositorio
  Future<List<Noticia>> loadMoreNoticias() async {
    try {
      final List<Noticia> noticias = await _repository.fetchNoticiasDesdeApi();

      if (noticias.isEmpty) {
        throw ApiException(
          'No encontramos noticias para mostrar. Por favor, intenta más tarde.',
          statusCode: 404
        );
      }

      // Validar cada noticia
      for (final noticia in noticias) {
        if (noticia.titulo.isEmpty || noticia.fuente.isEmpty || noticia.descripcion.isEmpty) {
          throw ApiException(
            'Algunas noticias tienen información incompleta.',
            statusCode: 400
          );
        }
      }
      
      return noticias;
    } catch (e) {
      if (e is ApiException) {
        // Propagar la excepción si ya es ApiException
        rethrow;
      } else {
        // Convertir otras excepciones a ApiException con mensaje amigable
        final errorMessage = ErrorHelper.getServiceErrorMessage(e.toString());
        throw ApiException(
          errorMessage,
          statusCode: _getStatusCodeFromError(e.toString())
        );
      }
    }
  }

  /// Crea una nueva noticia
  Future<Noticia> createNoticia(Noticia noticia) async {
    try {
      // Validación local
      if (noticia.titulo.isEmpty || noticia.descripcion.isEmpty || noticia.fuente.isEmpty) {
        throw ApiException(
          'Por favor, completa todos los campos requeridos.',
          statusCode: 400
        );
      }

      return await _repository.createNoticia(noticia);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        final errorMessage = ErrorHelper.getServiceErrorMessage(e.toString());
        throw ApiException(
          errorMessage,
          statusCode: _getStatusCodeFromError(e.toString())
        );
      }
    }
  }

  /// Actualiza una noticia existente
  Future<void> updateNoticia(String id, Noticia noticia) async {
    try {
      // Validación local
      if (noticia.titulo.isEmpty || noticia.descripcion.isEmpty || noticia.fuente.isEmpty) {
        throw ApiException(
          'Por favor, completa todos los campos requeridos.',
          statusCode: 400
        );
      }

      await _repository.updateNoticia(id, noticia);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        final errorMessage = ErrorHelper.getServiceErrorMessage(e.toString());
        throw ApiException(
          errorMessage,
          statusCode: _getStatusCodeFromError(e.toString())
        );
      }
    }
  }

  /// Elimina una noticia
  Future<void> deleteNoticia(String id) async {
    try {
      if (id.isEmpty) {
        throw ApiException(
          'No se puede eliminar la noticia porque el ID no es válido.',
          statusCode: 400
        );
      }

      await _repository.deleteNoticia(id);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        final errorMessage = ErrorHelper.getServiceErrorMessage(e.toString());
        throw ApiException(
          errorMessage,
          statusCode: _getStatusCodeFromError(e.toString())
        );
      }
    }
  }

  /// Método auxiliar para determinar el código de estado basado en el mensaje de error
  int _getStatusCodeFromError(String errorMessage) {
    errorMessage = errorMessage.toLowerCase();
    
    if (errorMessage.contains('error 404')) {
      return 404;
    } else if (errorMessage.contains('error 401') || errorMessage.contains('error 403')) {
      return 403;
    } else if (errorMessage.contains('error 400')) {
      return 400;
    } else if (errorMessage.contains('timeout')) {
      return 408;
    } else if (errorMessage.contains('socketexception')) {
      return 0; // Error de conectividad
    }
    
    return 500; // Error de servidor por defecto
  }
}
