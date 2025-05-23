import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class CategoriaService extends BaseService {
  CategoriaService() : super();

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final data = await get('/categorias', requireAuthToken: false);

      if (data is List) {
        final List<dynamic> categoriasJson = data;

        // Filtrar cualquier categoría que no se pueda deserializar correctamente
        List<Categoria> categorias = [];
        for (var json in categoriasJson) {
          try {
            if (json != null && json is Map<String, dynamic>) {
              _normalizarId(json);
              categorias.add(CategoriaMapper.fromMap(json));
            }
          } catch (e) {
            debugPrint('Error al deserializar categoría: $e');
            debugPrint('Datos problemáticos: $json');
            // Ignoramos esta categoría y continuamos con la siguiente
          }
        }
        return categorias;
      } else {
        debugPrint('❌ La respuesta no es una lista: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en getCategorias: ${e.toString()}');
      handleError(e);
      return []; // En caso de error, devolvemos una lista vacía
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en getCategorias: ${e.toString()}');
      throw ApiException('Error al obtener categorías: $e');
    }
  }

  /// Obtiene una categoría por su ID desde la API
  Future<Categoria> obtenerCategoriaPorId(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de categoría inválido', statusCode: 400);
      }

      final data = await get('/categorias/$id', requireAuthToken: false);

      if (data != null && data is Map<String, dynamic>) {
        try {
          _normalizarId(data);
          return CategoriaMapper.fromMap(data);
        } catch (e) {
          debugPrint('❌ Error al deserializar categoría: $e');
          throw ApiException('Error al procesar los datos de la categoría');
        }
      } else {
        debugPrint('❌ Respuesta no es un objeto: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en obtenerCategoriaPorId: ${e.toString()}');
      handleError(e);
      throw ApiException('Error al obtener la categoría');
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en obtenerCategoriaPorId: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      await post('/categorias', data: categoria, requireAuthToken: true);
    } on DioException catch (e) {
      debugPrint('❌ DioException en crearCategoria: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en crearCategoria: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(String id, Map<String, dynamic> categoria) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de categoría inválido', statusCode: 400);
      }
      await put('/categorias/$id', data: categoria, requireAuthToken: true);
    } on DioException catch (e) {
      debugPrint('❌ DioException en editarCategoria: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en editarCategoria: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de categoría inválido', statusCode: 400);
      }

      await delete('/categorias/$id', requireAuthToken: true);
    } on DioException catch (e) {
      debugPrint('❌ DioException en eliminarCategoria: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en eliminarCategoria: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Método auxiliar para normalizar el ID en la respuesta de la API
  void _normalizarId(Map<String, dynamic> json) {
    // Asegurarse de que siempre haya un 'id' para deserializar correctamente
    if (json['_id'] != null && json['id'] == null) {
      json['id'] = json['_id']; // Copiar '_id' a 'id' si solo existe '_id'
    }

    // Verificar que el ID exista
    if (json['id'] == null) {
      throw ApiException('Categoría sin identificador válido');
    }
  }
}
