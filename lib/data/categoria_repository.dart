import 'package:dio/dio.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/exceptions/api_exception.dart';


class CategoriaRepository {
  final Dio _dio;

  CategoriaRepository()
      : _dio = Dio(BaseOptions(
          baseUrl: Constants.categoriasUrl,
          connectTimeout: const Duration(seconds: Constants.timeoutSeconds * 1000),
          receiveTimeout: const Duration(seconds: Constants.timeoutSeconds * 1000),
        ));

  Future<List<Categoria>> getCategorias() async {
    try {

      final response = await _dio.get(Constants.categoriasUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        _handleHttpError(response.statusCode, response.data);
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw Exception(Constants.errorServer);
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      final response = await _dio.post(
        Constants.categoriasUrl,
        data: categoria,
      );


      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          'Tiempo de espera agotado',
          statusCode: 408,
        );
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }


  /// Edita una categoría existente en la API
  Future<void> editarCategoria(
    String id,
    Map<String, dynamic> categoria,
  ) async {
    try {
      final url = '${Constants.categoriasUrl}/$id';
      final response = await _dio.put(url, data: categoria);


      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          'Tiempo de espera agotado',
          statusCode: 408,
        );
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }


  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${Constants.categoriasUrl}/$id';
      final response = await _dio.delete(url);


      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          'Tiempo de espera agotado',
          statusCode: 408,
        );
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }


  void _handleHttpError(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        throw Exception('Error 400: Petición incorrecta');
      case 401:
        throw Exception(Constants.errorUnauthorized);
      case 404:
        throw Exception(Constants.errorNoCategory);
      case 500:
        throw Exception(Constants.errorServer);
      default:
        throw Exception('Error desconocido: Código de estado $statusCode');
    }
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception(Constants.errorTimeout);
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception(Constants.errorTimeout);
    } else if (e.type == DioExceptionType.badResponse) {
      _handleHttpError(e.response?.statusCode, e.response?.data);
    } else if (e.type == DioExceptionType.cancel) {
      throw Exception('Error: Solicitud cancelada');
    } else {
      throw Exception('${Constants.errorServer}: ${e.message}');
    }
  }
}
