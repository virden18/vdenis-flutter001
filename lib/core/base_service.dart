import 'dart:async';
import 'package:dio/dio.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/core/api_config.dart';
import 'package:vdenis/core/connectivity_service.dart';
import 'package:vdenis/core/secure_storage.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/error_helper.dart';

/// Clase base para todos los servicios de la API.
class BaseService {
  /// Cliente HTTP Dio
  late final Dio _dio;

  /// Servicio para almacenamiento seguro
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Servicio para verificar la conectividad a Internet
  final ConnectivityService _connectivityService = ConnectivityService();

  /// Constructor
  BaseService() {
    _initializeDio();
  }

  /// Inicializa el cliente Dio con configuraciones comunes
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.beeceptorBaseUrl,
        connectTimeout: const Duration(seconds: AppConstants.timeoutSeconds),
        receiveTimeout: const Duration(seconds: AppConstants.timeoutSeconds),
        headers: {
          'x-beeceptor-auth': ApiConfig.beeceptorApiKey,
          'Content-Type': 'application/json',
        },
      ),
    );
  }
  
  /// Obtiene opciones de solicitud con token de autenticación si es requerido
  Future<Options> _getRequestOptions({bool requireAuthToken = false}) async {
    final options = Options();

    if (requireAuthToken) {
      final jwt = await _secureStorage.getJwt();
      if (jwt != null && jwt.isNotEmpty) {
        options.headers = {...(options.headers ?? {}), 'X-Auth-Token': jwt};
      } else {
        throw ApiException(
          'No se encontró el token de autenticación',
          statusCode: 401,
        );
      }
    }

    return options;
  }

  /// Verifica la conectividad antes de realizar una solicitud
  Future<void> _checkConnectivityBeforeRequest() async {
    await _connectivityService.checkConnectivity();
  }

  /// Manejo centralizado de errores para servicios
  void handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(ErrorConstants.errorTimeOut);
    }

    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        throw ApiException(ErrorConstants.errorInvalidData, statusCode: 400);
      case 401:
        throw ApiException(ErrorConstants.errorUnauthorized, statusCode: 401);
      case 404:
        throw ApiException(ErrorConstants.errorNotFound, statusCode: 404);
      case 500:
        throw ApiException(ErrorConstants.errorServer, statusCode: 500);
      default:
        final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
        throw ApiException(
          errorData['message'] ??
              'Error desconocido: ${statusCode ?? 'Sin código'}',
          statusCode: statusCode,
        );
    }
  }

  /// Método GET genérico
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requireAuthToken = false,
  }) async {
    try {
      // Verificar conectividad antes de realizar la solicitud
      await _checkConnectivityBeforeRequest();
      final options = await _getRequestOptions(
        requireAuthToken: requireAuthToken,
      );
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return response.data;
    } on ApiException {
      // Re-lanzar excepciones de API (incluidas las de conectividad)
      rethrow;
    } on DioException catch (e) {
      handleError(e);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Método POST genérico
  Future<dynamic> post(
    String path, {
    dynamic data,
    bool requireAuthToken = false,
  }) async {
    try {
      // Verificar conectividad antes de realizar la solicitud
      await _checkConnectivityBeforeRequest();
      final options = await _getRequestOptions(
        requireAuthToken: requireAuthToken,
      );
      final response = await _dio.post(path, data: data, options: options);

      return response.data;
    } on ApiException {
      // Re-lanzar excepciones de API (incluidas las de conectividad)
      rethrow;
    } on DioException catch (e) {
      handleError(e);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Método PUT genérico
  Future<dynamic> put(
    String path, {
    dynamic data,
    bool requireAuthToken = false,
  }) async {
    try {
      // Verificar conectividad antes de realizar la solicitud
      await _checkConnectivityBeforeRequest();
      final options = await _getRequestOptions(
        requireAuthToken: requireAuthToken,
      );
      final response = await _dio.put(path, data: data, options: options);

      return response.data;
    } on ApiException {
      // Re-lanzar excepciones de API (incluidas las de conectividad)
      rethrow;
    } on DioException catch (e) {
      handleError(e);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Método DELETE genérico
  Future<dynamic> delete(String path, {bool requireAuthToken = false}) async {
    try {
      // Verificar conectividad antes de realizar la solicitud
      await _checkConnectivityBeforeRequest();
      final options = await _getRequestOptions(
        requireAuthToken: requireAuthToken,
      );
      final response = await _dio.delete(path, options: options);

      return response.data;
    } on ApiException {
      // Re-lanzar excepciones de API (incluidas las de conectividad)
      rethrow;
    } on DioException catch (e) {
      handleError(e);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Acceso protegido al cliente Dio para casos especiales
  Dio get dio => _dio;

  /// Acceso al servicio de conectividad
  ConnectivityService get connectivityService => _connectivityService;
}
