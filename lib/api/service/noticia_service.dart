import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/error_helper.dart';

class NoticiaService {
  final List<Noticia> noticias = [];
  final Dio _dio;

  NoticiaService() 
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: Constants.timeoutSeconds),
          receiveTimeout: const Duration(seconds: Constants.timeoutSeconds),
        )) {
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
        final errorData = ErrorHelper.getErrorMessageAndColor(response.statusCode ?? 500);
        throw ApiException(
          errorData['message'],
          statusCode: response.statusCode,
        );
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
          "categoriaId": noticia.categoriaId,
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
          categoriaId: noticia.categoriaId,
        );

        return createdNoticia;
      } else {
        final errorData = ErrorHelper.getErrorMessageAndColor(response.statusCode ?? 500);
        throw ApiException(
          'Error al crear la noticia: ${errorData['message']}',
          statusCode: response.statusCode,
        );
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
          "categoriaId": noticia.categoriaId,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Noticia actualizada exitosamente.');
        }
      } else {
        final errorData = ErrorHelper.getErrorMessageAndColor(response.statusCode ?? 500);
        throw ApiException(
          'Error al actualizar la noticia: ${errorData['message']}',
          statusCode: response.statusCode,
        );
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
        final errorData = ErrorHelper.getErrorMessageAndColor(response.statusCode ?? 500);
        throw ApiException(
          'Error al eliminar la noticia: ${errorData['message']}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al eliminar la noticia: $e');
      }
      throw _handleDioError(e, 'eliminar la noticia');
    }
  }

  // Método para centralizar el manejo de errores
  ApiException _handleDioError(dynamic error, String operation) {
    if (error is ApiException) {
      return error;
    }
    
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        // Usar ErrorHelper para mensajes de timeout
        return ApiException(
          ErrorHelper.getTimeoutMessage(),
          statusCode: 408,
        );
      } else if (error.type == DioExceptionType.connectionError) {
        // Usar ErrorHelper para errores de conexión
        return ApiException(
          'No se pudo conectar con el servidor. Verifica tu conexión a internet.',
          statusCode: 0,
        );
      } else if (error.response != null) {
        final statusCode = error.response!.statusCode ?? 500;
        String errorMessage;
        
        // Intentar extraer un mensaje de error del cuerpo de la respuesta
        if (error.response!.data is Map) {
          errorMessage = error.response!.data['message'] ?? 
                        error.response!.data['error'] ?? 
                        'Error $statusCode';
        } else if (error.response!.data is String && error.response!.data.toString().isNotEmpty) {
          errorMessage = error.response!.data.toString();
        } else {
          // Usar ErrorHelper para obtener un mensaje estándar según el código
          final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
          errorMessage = errorData['message'];
        }
        
        return ApiException(
          '$errorMessage al $operation',
          statusCode: statusCode,
        );
      }
      
      // Para otros tipos de errores Dio
      return ApiException(
        'Error en la comunicación con el servidor al $operation: ${error.message}',
        statusCode: 500,
      );
    }
    
    // Para otros tipos de errores genéricos
    return ApiException(
      'Error inesperado al $operation: $error',
      statusCode: 500,
    );
  }
}
