import 'dart:async';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/domain/reporte.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vdenis/core/base_service.dart';

class ReporteService extends BaseService {
  // Constructor
  ReporteService() : super();

  /// Obtiene todos los reportes
  Future<List<Reporte>> getReportes() async {
    try {
      final data = await get('/reportes', requireAuthToken: false);

      if (data is List) {
        debugPrint('📊 Procesando ${data.length} reportes');

        return data
            .map((json) {
              try {
                if (json is Map<String, dynamic>) {
                  return ReporteMapper.fromMap(json);
                } else {
                  return ReporteMapper.fromJson(json.toString());
                }
              } catch (e) {
                debugPrint('❌ Error al deserializar reporte: $e');
                // Retornar null y luego filtrar los nulos
                return null;
              }
            })
            .where((reporte) => reporte != null)
            .cast<Reporte>()
            .toList();
      } else {
        debugPrint('❌ La respuesta no es una lista: $data');
        throw ApiException(
          'Formato de respuesta inválido',
          statusCode: 500,
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en getReportes: ${e.toString()}');
      handleError(e);
      return []; // Retornar lista vacía en caso de error
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado: ${e.toString()}');
      throw ApiException('Error inesperado: $e', statusCode: 500);
    }
  }

  /// Crea un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      final fecha = DateTime.now().toIso8601String();
      final data = await post(
        '/reportes',
        data: {
          'noticiaId': noticiaId,
          'fecha': fecha,
          'motivo':
              motivo.toValue(), // Método para serializar el enum correctamente
        },
        requireAuthToken: true, // Operación de escritura
      );

      debugPrint('✅ Reporte creado correctamente');

      if (data is Map<String, dynamic>) {
        return ReporteMapper.fromMap(data);
      } else if (data != null) {
        return ReporteMapper.fromJson(data.toString());
      }
      return null;
    } on DioException catch (e) {
      debugPrint('❌ DioException en crearReporte: ${e.toString()}');
      handleError(e);
      return null;
    } catch (e) {
      debugPrint('❌ Error inesperado en crearReporte: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: $e', statusCode: 500);
    }
  }

  /// Obtiene reportes por ID de noticia
  Future<List<Reporte>> getReportesPorNoticia(String noticiaId) async {
    try {
      final reportes = await getReportes();
      return reportes
          .where((reporte) => reporte.noticiaId == noticiaId)
          .toList();
    } catch (e) {
      debugPrint('❌ Error en getReportesPorNoticia: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        'Error al obtener reportes por noticia: $e',
        statusCode: 500,
      );
    }
  }

  /// Elimina un reporte
  Future<void> eliminarReporte(String reporteId) async {
    try {
      await delete('/reportes/$reporteId', requireAuthToken: true);
      debugPrint('✅ Reporte eliminado correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en eliminarReporte: ${e.toString()}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en eliminarReporte: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: $e', statusCode: 500);
    }
  }

  /// Actualiza un reporte existente
  Future<Reporte?> actualizarReporte(
    String reporteId,
    Map<String, dynamic> datosActualizados,
  ) async {
    try {
      final data = await put(
        '/reportes/$reporteId',
        data: datosActualizados,
        requireAuthToken: true, // Operación de escritura
      );

      debugPrint('✅ Reporte actualizado correctamente');

      if (data is Map<String, dynamic>) {
        return ReporteMapper.fromMap(data);
      } else if (data != null) {
        return ReporteMapper.fromJson(data.toString());
      }
      return null;
    } on DioException catch (e) {
      debugPrint('❌ DioException en actualizarReporte: ${e.toString()}');
      handleError(e);
      return null;
    } catch (e) {
      debugPrint('❌ Error inesperado en actualizarReporte: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: $e', statusCode: 400);
    }
  }
}