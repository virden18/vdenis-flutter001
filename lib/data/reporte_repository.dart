import 'package:vdenis/api/service/reporte_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/reporte.dart';

class ReporteRepository extends BaseRepository {
  final ReporteService _reporteService = ReporteService();

  // Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    return get(
      serviceGet: _reporteService.getReportes,
      operacion: 'obtener todos los reportes',
    );
  }

  // Obtener el número de reportes para una noticia
  Future<int> obtenerNumeroReportes(String noticiaId) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');

    return executeServiceCall(
      serviceCall: () async {
        final reportes = await _reporteService.getReportesPorNoticia(noticiaId);
        return reportes.length;
      },
      operacion: 'contar reportes para noticia $noticiaId',
    );
  }

  // Obtener el número de reportes por motivo para una noticia
  Future<int> obtenerNumeroReportesPorMotivo(String noticiaId, MotivoReporte motivo) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');

    return executeServiceCall(
      serviceCall: () async {
        final reportes = await _reporteService.getReportesPorNoticia(noticiaId);
        return reportes.where((reporte) => reporte.motivo == motivo).length;
      },
      operacion: 'contar reportes por motivo para noticia $noticiaId',
    );
  }

  // Crear un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');

    return executeServiceCall(
      serviceCall: () => _reporteService.crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      ),
      operacion: 'crear reporte para noticia $noticiaId',
    );
  }

  // Obtener reportes por id de noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');

    return executeServiceCall(
      serviceCall: () => _reporteService.getReportesPorNoticia(noticiaId),
      operacion: 'obtener reportes para noticia $noticiaId',
    );
  }

  // Eliminar un reporte
  Future<void> eliminarReporte(String reporteId) async {
    validateId(reporteId, mensaje: 'ID de reporte no válido');

    return delete(
      serviceDelete: _reporteService.eliminarReporte,
      id: reporteId,
      operacion: 'eliminar reporte $reporteId',
    );
  }
}