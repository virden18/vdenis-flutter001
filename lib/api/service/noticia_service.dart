import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/domain/noticia.dart';

class NoticiaServiceException implements Exception {
  final String message;
  final String userFriendlyMessage;
  final dynamic originalError;

  NoticiaServiceException({
    required this.message,
    required this.userFriendlyMessage,
    this.originalError,
  });

  @override
  String toString() => message;
}

class NoticiaService {
  final NoticiaRepository _repository = NoticiaRepository();

  Future<List<Noticia>> loadMoreNoticias() async {
    try {
      final List<Noticia> noticias = await _repository.fetchNoticiasDesdeApi();

      if (noticias.isEmpty) {
        throw NoticiaServiceException(
          message: 'No hay más noticias disponibles.',
          userFriendlyMessage:
              'No encontramos noticias para mostrar. Por favor, intenta más tarde.',
        );
      }

      for (final noticia in noticias) {
        if (noticia.titulo.isEmpty ||
            noticia.fuente.isEmpty ||
            noticia.descripcion.isEmpty) {
          throw NoticiaServiceException(
            message:
                'El título, descripción o fuente de la noticia no pueden estar vacíos.',
            userFriendlyMessage:
                'Algunas noticias tienen información incompleta. Contacta con el administrador.',
          );
        }
      }
      return noticias;
    } catch (e) {
      if (e is NoticiaServiceException) {
        rethrow; // Ya está formateado, simplemente lo relanzamos
      }

      // Interpretación de errores del repositorio
      String userFriendlyMessage;

      if (e.toString().contains('Error 404')) {
        userFriendlyMessage =
            'No se pudo encontrar el recurso solicitado. Por favor, verifica la conexión.';
      } else if (e.toString().contains('Error 401') ||
          e.toString().contains('Error 403')) {
        userFriendlyMessage =
            'No tienes acceso a esta información. Contacta con el administrador.';
      } else if (e.toString().contains('DioException') &&
          e.toString().contains('SocketException')) {
        userFriendlyMessage =
            'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
      } else if (e.toString().contains('timeout')) {
        userFriendlyMessage =
            'La conexión tardó demasiado tiempo. Inténtalo de nuevo más tarde.';
      } else {
        userFriendlyMessage =
            'Ocurrió un error al cargar las noticias. Por favor, intenta de nuevo.';
      }

      throw NoticiaServiceException(
        message: 'Error en el servicio de noticias: $e',
        userFriendlyMessage: userFriendlyMessage,
        originalError: e,
      );
    }
  }

  Future<void> createNoticia(Noticia noticia) async {
    try {
      // Validación antes de enviar al repositorio
      if (noticia.titulo.isEmpty ||
          noticia.descripcion.isEmpty ||
          noticia.fuente.isEmpty) {
        throw NoticiaServiceException(
          message: 'Campos requeridos vacíos',
          userFriendlyMessage:
              'Por favor, completa todos los campos requeridos.',
        );
      }

      await _repository.createNoticia(noticia);
    } catch (e) {
      if (e is NoticiaServiceException) {
        rethrow;
      }

      // Interpretación de errores de creación
      String userFriendlyMessage;

      if (e.toString().contains('Error 400')) {
        userFriendlyMessage =
            'Los datos proporcionados no son válidos. Revisa la información.';
      } else if (e.toString().contains('Error 401') ||
          e.toString().contains('Error 403')) {
        userFriendlyMessage =
            'No tienes permisos para crear noticias. Contacta con el administrador.';
      } else if (e.toString().contains('SocketException')) {
        userFriendlyMessage =
            'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
      } else {
        userFriendlyMessage =
            'Ocurrió un error al crear la noticia. Por favor, intenta de nuevo.';
      }

      throw NoticiaServiceException(
        message: 'Error al crear noticia: $e',
        userFriendlyMessage: userFriendlyMessage,
        originalError: e,
      );
    }
  }

  Future<void> updateNoticia(String id, Noticia noticia) async {
    try {
      // Validación antes de enviar al repositorio
      if (noticia.titulo.isEmpty ||
          noticia.descripcion.isEmpty ||
          noticia.fuente.isEmpty) {
        throw NoticiaServiceException(
          message: 'Campos requeridos vacíos',
          userFriendlyMessage:
              'Por favor, completa todos los campos requeridos.',
        );
      }

      await _repository.updateNoticia(id, noticia);
    } catch (e) {
      if (e is NoticiaServiceException) {
        rethrow;
      }

      // Interpretación de errores de actualización
      String userFriendlyMessage;

      if (e.toString().contains('Error 400')) {
        userFriendlyMessage =
            'Los datos proporcionados no son válidos. Revisa la información.';
      } else if (e.toString().contains('Error 401') ||
          e.toString().contains('Error 403')) {
        userFriendlyMessage =
            'No tienes permisos para actualizar noticias. Contacta con el administrador.';
      } else if (e.toString().contains('Error 404')) {
        userFriendlyMessage =
            'No se encontró la noticia. Puede haber sido eliminada.';
      } else if (e.toString().contains('SocketException')) {
        userFriendlyMessage =
            'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
      } else {
        userFriendlyMessage =
            'Ocurrió un error al actualizar la noticia. Por favor, intenta de nuevo.';
      }

      throw NoticiaServiceException(
        message: 'Error al actualizar noticia: $e',
        userFriendlyMessage: userFriendlyMessage,
        originalError: e,
      );
    }
  }

  Future<void> deleteNoticia(String id) async {
    try {
      if (id.isEmpty) {
        throw NoticiaServiceException(
          message: 'ID de noticia no válido',
          userFriendlyMessage:
              'No se puede eliminar la noticia porque el ID no es válido.',
        );
      }

      await _repository.deleteNoticia(id);
    } catch (e) {
      if (e is NoticiaServiceException) {
        rethrow;
      }

      // Interpretación de errores de eliminación
      String userFriendlyMessage;

      if (e.toString().contains('Error 404')) {
        userFriendlyMessage =
            'No se encontró la noticia. Puede haber sido eliminada previamente.';
      } else if (e.toString().contains('Error 401') ||
          e.toString().contains('Error 403')) {
        userFriendlyMessage =
            'No tienes permisos para eliminar esta noticia. Contacta con el administrador.';
      } else if (e.toString().contains('SocketException')) {
        userFriendlyMessage =
            'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
      } else {
        userFriendlyMessage =
            'Ocurrió un error al eliminar la noticia. Por favor, intenta de nuevo.';
      }

      throw NoticiaServiceException(
        message: 'Error al eliminar noticia: $e',
        userFriendlyMessage: userFriendlyMessage,
        originalError: e,
      );
    }
  }
}
