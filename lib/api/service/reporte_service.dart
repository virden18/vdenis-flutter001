import 'dart:async';
import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/reporte.dart';


class ReporteService extends BaseService {
  Future<void> enviarReporte(Reporte reporte) async {
    await post(
      ApiConstantes.reportesEndpoint,
      data: reporte.toMap(),
      errorMessage: ReporteConstantes.errorCrear,
    );
  }

  Future<List<Reporte>> obtenerReportes(noticiaId) async {
    final List<dynamic> reportesJson = await get<List<dynamic>>(
      '${ApiConstantes.reportesEndpoint}?noticiaId=$noticiaId',
      errorMessage: ReporteConstantes.errorObtenerReportes,
    );
    return reportesJson
        .map<Reporte>(
          (json) => ReporteMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> eliminarReportesPorNoticia(String noticiaId) async {
    final reportes = await obtenerReportes(noticiaId);
    for (final reporte in reportes) {
      if (reporte.id != null) {
        await delete(
          '${ApiConstantes.reportesEndpoint}/${reporte.id}',
          errorMessage: ReporteConstantes.errorEliminarReportes,
        );
      }
    }
  }
}