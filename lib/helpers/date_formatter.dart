import 'package:intl/intl.dart';

class DateFormatter {

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
      return fecha;
    }
  }
  
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
}