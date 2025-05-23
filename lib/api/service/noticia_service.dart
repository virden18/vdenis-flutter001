import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class NoticiaService extends BaseService {
  
  NoticiaService() : super();

  /// Obtiene todas las noticias desde la API
  Future<List<Noticia>> getNoticias() async {
    try {
      // Utilizamos el método get() de BaseService
      final data = await get(ApiConstants.endpointNoticias, requireAuthToken: false);

      if (data is List) {
        final List<dynamic> articlesJson = data;

        if (articlesJson.isEmpty) {
          return [];
        }

        // Mapear respuesta a objetos Noticia
        List<Noticia> noticias = [];
        for (var json in articlesJson) {

            if (json != null && json is Map<String, dynamic>) {
              noticias.add(NoticiaMapper.fromMap(json));
          } 
        }
        return noticias;
      } else {
        debugPrint('❌ La respuesta no es una lista: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en fetchNoticiasDesdeApi: ${e.toString()}');
      handleError(e);
      return []; // En caso de error, devolvemos una lista vacía
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en fetchNoticiasDesdeApi: ${e.toString()}');
      throw ApiException('Error al obtener noticias: $e');
    }
  }

  /// Crea una nueva noticia
  Future<void> createNoticia(Map<String, dynamic> noticia) async {
    try {
      // Utilizamos el método post() de BaseService
      await post(
        ApiConstants.endpointNoticias,
        data: noticia,
        requireAuthToken: true,
      );
    } on DioException catch (e) {
      debugPrint('❌ DioException en createNoticia: ${e.toString()}');
      handleError(e);
      throw ApiException('Error al crear la noticia');
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en createNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Actualiza una noticia existente
  Future<void> updateNoticia(String id, Map<String, dynamic> noticia) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de noticia inválido', statusCode: 400);
      }

      // Utilizamos el método put() de BaseService
      await put(
        '${ApiConstants.endpointNoticias}/$id',
        data: noticia,
        requireAuthToken: true,
      );

    } on DioException catch (e) {
      debugPrint('❌ DioException en updateNoticia: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en updateNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Elimina una noticia
  Future<void> deleteNoticia(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de noticia inválido', statusCode: 400);
      }

      // Utilizamos el método delete() de BaseService
      await delete(
        '${ApiConstants.endpointNoticias}/$id',
        requireAuthToken: true,
      );
      
    } on DioException catch (e) {
      debugPrint('❌ DioException en deleteNoticia: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en deleteNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Obtener una noticia por ID
  Future<Noticia?> getNoticiaPorId(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de noticia inválido', statusCode: 400);
      }

      // Si no está en caché, buscar en la API
      final data = await get(
        '${ApiConstants.endpointNoticias}/$id', 
        requireAuthToken: false,
      );

      if (data != null && data is Map<String, dynamic>) {
        return NoticiaMapper.fromMap(data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en getNoticiaPorId: ${e.toString()}');
      handleError(e);
      return null;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en getNoticiaPorId: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
}
