import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/noticia.dart';

class NoticiaRepository {
  final List<Noticia> noticias = [];
  final Dio _dio = Dio();

  NoticiaRepository() {
    _initializeNoticias();
  }

  Future<void> _initializeNoticias() async {
    try {
      final List<Noticia> apiNoticias = await fetchNoticiasDesdeApi();
      noticias.addAll(apiNoticias);
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar las noticias: $e');
      }
    }
  }

  Future<List<Noticia>> fetchNoticiasDesdeApi() async {
    try {
      final response = await _dio.get(Constants.newsUrl);

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data as List<dynamic>;

        if (articles.isEmpty) {
          return [];
        }

        return articles.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las noticias: ${response.statusCode}');
      }
    } catch (e) {
      throw _handleDioError(e, 'obtener las noticias');
    }
  }

  Future<Noticia> createNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        Constants.newsUrl,
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "urlImagen": noticia.urlImagen,
        },
      );

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('Noticia creada exitosamente.');
        }

        // Crear una nueva noticia con el ID asignado por el servidor
      final createdNoticia = Noticia(
        id: response.data['_id'] ?? noticia.id, // Usar el ID del servidor
        titulo: noticia.titulo,
        descripcion: noticia.descripcion,
        fuente: noticia.fuente,
        publicadaEl: noticia.publicadaEl,
        urlImagen: noticia.urlImagen,
      );

      return createdNoticia;
      } else {
        throw Exception('Error al crear la noticia: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al realizar la solicitud: $e');
      }
      throw _handleDioError(e, 'crear la noticia');
    }
  }

  Future<void> updateNoticia(String id, Noticia noticia) async {
  try {
    final response = await _dio.put(
      "${Constants.newsUrl}/$id",
      data: {
        "titulo": noticia.titulo,
        "descripcion": noticia.descripcion,
        "fuente": noticia.fuente,
        "publicadaEl": noticia.publicadaEl.toIso8601String(),
        "urlImagen": noticia.urlImagen,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Noticia actualizada exitosamente.');
      }
    } else {
      throw Exception('Error al actualizar la noticia: ${response.statusCode}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error al actualizar la noticia: $e');
    }
    throw _handleDioError(e, 'actualizar la noticia');
  }
}

Future<void> deleteNoticia(String id) async {
  try {
    final response = await _dio.delete("${Constants.newsUrl}/$id");

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        print('Noticia eliminada exitosamente.');
      }
    } else {
      throw Exception('Error al eliminar la noticia: ${response.statusCode}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error al eliminar la noticia: $e');
    }
    throw _handleDioError(e, 'eliminar la noticia');
  }
}

  /// Método auxiliar para manejar errores de Dio y generar excepciones descriptivas
  Exception _handleDioError(dynamic error, String operation) {
    // Verificar si es un error de Dio con respuesta
    if (error is DioException && error.response != null) {
      final statusCode = error.response!.statusCode;
      
      // Si es un error 4xx, extraer información más detallada
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        String errorMessage;
        
        // Intentar extraer un mensaje de error del cuerpo de la respuesta
        if (error.response!.data is Map) {
          errorMessage = error.response!.data['message'] ?? 
                         error.response!.data['error'] ?? 
                         'Error $statusCode';
        } else if (error.response!.data is String && error.response!.data.isNotEmpty) {
          errorMessage = error.response!.data;
        } else {
          errorMessage = 'Error del cliente: $statusCode';
        }
        
        return Exception('Error $statusCode al $operation: $errorMessage');
      }
    }
    
    // Para otros tipos de errores, mantener el comportamiento genérico
    return Exception('Error al $operation: $error');
  }
}
