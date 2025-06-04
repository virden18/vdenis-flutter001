import 'package:flutter/material.dart';
import 'package:vdenis/domain/reporte.dart';

class ReporteIconHelper {
  static Widget buildReporteButton({
    required MotivoReporte motivo,
    required int contadorReportes,
    required bool yaReportado,
    required VoidCallback onTap,
  }) {
    IconData icono;
    Color color;
    String tooltip;
    
    switch (motivo) {
      case MotivoReporte.noticiaInapropiada:
        icono = Icons.block;
        color = Colors.red;
        tooltip = 'Contenido inapropiado';
        break;
      case MotivoReporte.informacionFalsa:
        icono = Icons.warning;
        color = Colors.orange;
        tooltip = 'Información falsa';
        break;
      case MotivoReporte.otro:
        icono = Icons.flag;
        color = Colors.blue;
        tooltip = 'Otro problema';
        break;
    }
    
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icono,
            color: yaReportado ? Colors.grey : color,
          ),
          tooltip: yaReportado ? 'Ya reportado' : tooltip,
        ),
        Text(
          contadorReportes.toString(),
          style: TextStyle(
            color: yaReportado ? Colors.grey : Colors.black87,
          ),
        ),
      ],
    );
  }
  
  static String getMotivoDescript(MotivoReporte motivo) {
    switch (motivo) {
      case MotivoReporte.noticiaInapropiada:
        return 'Contenido inapropiado';
      case MotivoReporte.informacionFalsa:
        return 'Información falsa';
      case MotivoReporte.otro:
        return 'Otro problema';
    }
  }
}