import 'package:vdenis/api/service/reporte_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/reporte.dart';

class ReporteRepository extends BaseRepository<Reporte> {
  final ReporteService _reporteService = ReporteService();

  @override
  void validarEntidad(Reporte reporte) {
    // Validaciones adicionales si es necesario
  }

  /// Crea un nuevo reporte
  Future<void> enviarReporte(String noticiaId, MotivoReporte motivo) async {
    return manejarExcepcion(() async {
      // Crear el objeto Reporte
      final reporte = Reporte(
        noticiaId: noticiaId,
        fecha: DateTime.now().toIso8601String(),
        motivo: motivo,
      );
      _reporteService.enviarReporte(reporte);
    }, mensajeError: ReporteConstantes.errorCrear);
  }

  /// Obtiene estadísticas de reportes de una noticia específica
  Future<Map<MotivoReporte, int>> obtenerEstadisticasReportesPorNoticia(
    String noticiaId,
  ) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, 'ID de la noticia');

      final reportes = await _reporteService.obtenerReportes(noticiaId);
      final estadisticas = <MotivoReporte, int>{};

      // Inicializar contadores
      for (final motivo in MotivoReporte.values) {
        estadisticas[motivo] = 0;
      }

      // Contar reportes por motivo para esta noticia
      for (final reporte in reportes) {
        estadisticas[reporte.motivo] = (estadisticas[reporte.motivo] ?? 0) + 1;
      }

      return estadisticas;
    }, mensajeError: 'Error al obtener estadísticas por noticia');
  }

  /// Elimina todos los reportes asociados a una noticia
  Future<void> eliminarReportesPorNoticia(String noticiaId) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, 'ID de la noticia');
      await _reporteService.eliminarReportesPorNoticia(noticiaId);
    }, mensajeError: ReporteConstantes.errorEliminarReportes);
  }
}