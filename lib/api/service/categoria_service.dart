import 'package:dio/dio.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/error_helper.dart'; // Asegúrate de importar el ErrorHelper

class CategoriaService {
  final Dio _dio;

  CategoriaService()
      : _dio = Dio(BaseOptions(
          baseUrl: NewsConstants.categoriasUrl,
          connectTimeout: const Duration(seconds: AppConstants.timeoutSeconds),
          receiveTimeout: const Duration(seconds: AppConstants.timeoutSeconds),
        ));

  /// Método para centralizar el manejo de errores
  ApiException _handleDioError(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return ApiException(
          ErrorHelper.getTimeoutMessage(),
          statusCode: 408,
        );
      } else if (error.type == DioExceptionType.badResponse) {
        final statusCode = error.response?.statusCode ?? 500;
        final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
        return ApiException(
          errorData['message'],
          statusCode: statusCode,
        );
      }
      return ApiException(
        error.message ?? 'Error desconocido',
        statusCode: 500,
      );
    }
    
    return ApiException(
      error,
      statusCode: 500,
    );
  }

  /// Obtiene la lista de categorías de la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _dio.get(NewsConstants.categoriasUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        final errorData = ErrorHelper.getErrorMessageAndColor(response.statusCode ?? 500);
        throw ApiException(
          errorData['message'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      final response = await _dio.post(
        NewsConstants.categoriasUrl,
        data: categoria,
      );

      if (response.statusCode != 201) {
        final errorData = ErrorHelper.getErrorMessageAndColor(response.statusCode ?? 500);
        throw ApiException(
          errorData['message'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(
    String id,
    Map<String, dynamic> categoria,
  ) async {
    try {
      final url = '${NewsConstants.categoriasUrl}/$id';
      final response = await _dio.put(url, data: categoria);

      if (response.statusCode != 200) {
        final errorData = ErrorHelper.getErrorMessageAndColor(response.statusCode ?? 500);
        throw ApiException(
          errorData['message'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${NewsConstants.categoriasUrl}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorData = ErrorHelper.getErrorMessageAndColor(response.statusCode ?? 500);
        throw ApiException(
          errorData['message'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw _handleDioError(e);
    }
  }
}