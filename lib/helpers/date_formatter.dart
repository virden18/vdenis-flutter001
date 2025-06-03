import 'package:intl/intl.dart';

class DateFormatter {
  /// Convierte una fecha ISO en formato String a una representación más legible
  /// 
  /// Formatos de salida:
  /// - "Ahora mismo" - si es hace menos de 1 minuto
  /// - "Hace X minutos" - si es hace menos de 1 hora
  /// - "Hace X horas" - si es hace menos de 1 día
  /// - "Hace X días" - si es hace menos de 7 días
  /// - "DD/MM/YYYY HH:MM" - para fechas más antiguas
  /// 
  /// Si la fecha no puede ser parseada, devuelve la fecha original
  static String formatearFecha(String fecha) {
    try {
      final DateTime fechaDateTime = DateTime.parse(fecha);
      final DateTime ahora = DateTime.now();
      final Duration diferencia = ahora.difference(fechaDateTime);
      
      if (diferencia.inMinutes < 1) {
        return "Ahora mismo";
      } else if (diferencia.inMinutes < 60) {
        return "Hace ${diferencia.inMinutes} minutos";
      } else if (diferencia.inHours < 24) {
        return "Hace ${diferencia.inHours} horas";
      } else if (diferencia.inDays < 7) {
        return "Hace ${diferencia.inDays} días";
      } else {
        return DateFormat('dd/MM/yyyy HH:mm').format(fechaDateTime);
      }
    } catch (e) {
      // Si hay algún error en el parseo, mostrar la fecha original
      return fecha;
    }
  }
  
  /// Formatea una fecha DateTime a formato relativo (hace cuánto tiempo)
  static String formatearFechaRelativa(DateTime fechaDateTime) {
    final DateTime ahora = DateTime.now();
    final Duration diferencia = ahora.difference(fechaDateTime);
    
    if (diferencia.inMinutes < 1) {
      return "Ahora mismo";
    } else if (diferencia.inMinutes < 60) {
      return "Hace ${diferencia.inMinutes} minutos";
    } else if (diferencia.inHours < 24) {
      return "Hace ${diferencia.inHours} horas";
    } else if (diferencia.inDays < 7) {
      return "Hace ${diferencia.inDays} días";
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(fechaDateTime);
    }
  }
  
  /// Formatea una fecha DateTime a un formato personalizado
  static String formatearFechaConFormato(DateTime fecha, String formato) {
    return DateFormat(formato).format(fecha);
  }
  
  /// Obtiene el nombre del mes a partir de su número (1-12)
  static String obtenerNombreMes(int mes) {
    const List<String> meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    
    if (mes >= 1 && mes <= 12) {
      return meses[mes - 1];
    }
    return '';
  }
}