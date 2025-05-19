import 'package:flutter/foundation.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class BaseRepository {
  void handleError(
    dynamic error, {
    String operacion = 'realizar la operación',
  }) {
    final String mensaje =
        error is ApiException
            ? error.message
            : 'Error al $operacion: ${error.toString()}';
    debugPrint('Error en repositorio: $mensaje');
    if (error is ApiException) {
      throw error; // Relanzar ApiException para mantener el código de estado
    } else {
      throw ApiException(mensaje);
    }
  }

  /// Ejecuta una operación de forma segura, manejando excepciones
  /// y transformando errores genéricos a ApiException
  /// [T] es un tipo de dato génerico que representa el tipo de respuesta esperada
  Future<T> _executeServiceCall<T>({
    required Future<T> Function() serviceCall,
    String operacion = 'realizar la operación',
  }) async {
    try {
      return await serviceCall();
    } on ApiException catch (e) {
      handleError(e, operacion: operacion);
      rethrow; // Esta línea nunca se ejecutará si handleError relanza la excepción
    } catch (e) {
      handleError(e, operacion: operacion);
      rethrow; // Esta línea nunca se ejecutará si handleError relanza la excepción
    }
  }

  Future<T> get<T>({
    required Future<T> Function() serviceGet,
    String operacion = 'obtener datos',
  }) async {
    return _executeServiceCall(serviceCall: serviceGet, operacion: operacion);
  }

  // [D] es un tipo de dato genérico que representa el tipo de datos a enviar
  Future<void> create<D>({
    required Future<void> Function(D data) serviceCreate,
    required D data,
    String operacion = 'crear recurso',
  }) async {
    return _executeServiceCall(
      serviceCall: () => serviceCreate(data),
      operacion: operacion,
    );
  }

  // [D] es un tipo de dato genérico que representa el tipo de datos a enviar
  // [ID] es un tipo de dato genérico que representa el tipo de ID
  Future<void> update<D, ID>({
    required Future<void> Function(ID id, D data) serviceUpdate,
    required ID id,
    required D data,
    String operacion = 'actualizar datos',
  }) async {
    return _executeServiceCall(
      serviceCall: () => serviceUpdate(id, data),
      operacion: operacion,
    );
  }

  Future<void> delete<ID>({
    required Future<void> Function(ID id) serviceDelete,
    required ID id,
    String operacion = 'eliminar recurso',
  }) async {
    return _executeServiceCall(
      serviceCall: () => serviceDelete(id),
      operacion: operacion,
    );
  }
}
