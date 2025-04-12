import 'package:flutter/material.dart';

class CommonWidgetsHelper {
  static Widget buildBoldAppBarTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 27,
      ),
    );
  }

  // Método para construir un título en negrita con tamaño 20
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }

  // Método para construir hasta 3 líneas de información
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line1, style: const TextStyle( color: Colors.grey),),
        buildSpacing(width: 10),
        if (line2 != null) Text(line2,
          style: const TextStyle(color: Colors.grey),),
        if (line3 != null) Text(line3, 
          style: const TextStyle( color: Colors.grey),),
      ],
    );
  }

  // Método para construir un pie de página en negrita
  static Widget buildBoldFooter(String footer) {
    return Text(
      footer,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Método para construir un SizedBox
  static Widget buildSpacing({double height = 0, double width = 0}) {
    return SizedBox(height: height, width: width);
  }

  // Método para construir un borde redondeado
  static RoundedRectangleBorder buildRoundedBorder() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
  }

  static Widget buildTextFieldController (TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  static Widget buildButtonStyle (String title) {
    return Text (
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }

  static Widget buildSnackBar (String message) {
    return SnackBar(
      content: Text(message),
    );
  }
}