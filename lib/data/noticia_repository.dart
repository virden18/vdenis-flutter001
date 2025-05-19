import 'package:flutter/material.dart';
import 'package:vdenis/api/service/noticia_service.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/error_helper.dart';

class NoticiaRepository {
  final NoticiaService _noticiaService = NoticiaService();

  /// Carga noticias desde el repositorio
  Future<List<Noticia>> getNoticias() async {
    try {
      final List<Noticia> noticias = await _noticiaService.getNoticias();

      if (noticias.isEmpty ) {
        return [];
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

   Future<void> crearNoticia(Map<String, dynamic> noticiaData) async {
    try {
      // Llama al método del repositorio para crear la categoría
      await _noticiaService.createNoticia(noticiaData);
      debugPrint('Noticia creada exitosamente.');
    } catch (e) {
      debugPrint('Error en NoticiaService al crear categoría: $e');
      rethrow;
    }
  }

  Future<void> actualizarNoticia(String id, Map<String, dynamic> noticiaData) async {
    try {
      // Llama al método del repositorio para editar la categoría
      await _noticiaService.updateNoticia(id, noticiaData);
      debugPrint('Noticia con ID $id actualizada exitosamente.');
    } catch (e) {
      debugPrint('Error en NoticiaService al actualizar categoría $id: $e');
      rethrow;
    }
  }

  /// Elimina una categoría
  Future<void> eliminarNoticia(String id) async {
    try {
      await _noticiaService.deleteNoticia(id);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de noticias: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
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
