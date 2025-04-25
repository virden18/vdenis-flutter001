import 'package:flutter/material.dart';

class ErrorHelper {
  /// Devuelve un mensaje y un color basado en el código HTTP
  static Map<String, dynamic> getErrorMessageAndColor(int? statusCode) {
    String message;
    Color color;

    switch (statusCode) {
      case 400:
        message = 'Solicitud incorrecta. Verifica los datos enviados.';
        color = Colors.orange;
        break;
      case 401:
        message = 'No autorizado. Verifica tus credenciales.';
        color = Colors.red;
        break;
      case 403:
        message = 'Prohibido. No tienes permisos para acceder.';
        color = Colors.redAccent;
        break;
      case 404:
        message = 'Recurso no encontrado. Verifica la URL.';
        color = Colors.blueGrey;
        break;
      case 500:
        message = 'Error interno del servidor. Intenta más tarde.';
        color = Colors.red;
        break;
      default:
        message = 'Ocurrió un error desconocido.';
        color = Colors.grey;
        break;
    }

    return {'message': message, 'color': color};
  }

  static String getTimeoutMessage() {
  return 'El servidor tardó demasiado en responder. Por favor, intenta de nuevo más tarde.';
}

static String getServiceErrorMessage(String errorString) {
  errorString = errorString.toLowerCase();
  
  if (errorString.contains('error 404')) {
    return 'No se encontró el recurso solicitado.';
  } else if (errorString.contains('error 401') || errorString.contains('error 403')) {
    return 'No tienes permisos para realizar esta acción.';
  } else if (errorString.contains('error 400')) {
    return 'Los datos proporcionados no son válidos.';
  } else if (errorString.contains('timeout')) {
    return 'La conexión tardó demasiado tiempo. Inténtalo de nuevo más tarde.';
  } else if (errorString.contains('socketexception')) {
    return 'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
  }
  
  return 'Ocurrió un error inesperado. Por favor, intenta de nuevo.';
}
}
