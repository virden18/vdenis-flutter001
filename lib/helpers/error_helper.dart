import 'package:flutter/material.dart';

class ErrorHelper {
  static Color getErrorColor(int statusCode) {
    Color color;
    switch (statusCode) {
      case 400:
        color = Colors.red;
        break;
      case 401:
        color = Colors.orange;
        break;
      case 403:
      case 562:
        color = Colors.redAccent;
        break;
      case 404:
        color = Colors.grey;
        break;
      case 429:
        color = Colors.amber;
        break;
      case 500:
        color = Colors.red;
        break;
      case 503:
        color = Colors.red;
        break;
      case 561:
        color = Colors.pink;
        break;
      case 571:
      case 572:
      case 573:
      case 574:
      case 575:
      case 576:
      case 577:
      case 578:
        color = Colors.cyan;
        break;
      case 580:
        color = Colors.blue;
        break;
      case 581:
        color = Colors.lime;
        break;
      case 599:
        color = Colors.red[900]!;
        break;
      default:
        color = Colors.purple;
        break;
    }
    return  color;
  }
}
