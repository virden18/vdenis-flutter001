// Añadir en error_helper.dart o crear un nuevo archivo como message_helper.dart

import 'package:flutter/material.dart';
import 'package:vdenis/helpers/error_helper.dart';

class MessageHelper {
  /// Muestra un SnackBar con estilo consistente en toda la aplicación
  /// 
  /// [context] - El BuildContext actual
  /// [message] - El mensaje a mostrar
  /// [isSuccess] - Si es un mensaje de éxito (verde)
  /// [statusCode] - Código de estado HTTP para determinar color y mensaje
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isSuccess = false,
    int? statusCode,
  }) {
    late String displayMessage;
    late Color backgroundColor;
    
    if (isSuccess) {
      // Para mensajes de éxito
      displayMessage = message;
      backgroundColor = Colors.green;
    } else if (statusCode != null) {
      // Para errores con código de estado (usar ErrorHelper)
      final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
      displayMessage = message.isNotEmpty ? message : errorData['message'];
      backgroundColor = errorData['color'];
    } else {
      // Para otros tipos de errores sin código de estado
      displayMessage = message;
      backgroundColor = Colors.red;
    }

    // Mostrar SnackBar con el mensaje y color correspondiente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(displayMessage),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: isSuccess ? 2 : 5),
      ),
    );
  }
}