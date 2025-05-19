
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/snackbar_helper.dart';


/// Servicio para verificar la conectividad a Internet
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Verifica si el dispositivo tiene conectividad a Internet
  /// Retorna true si hay conexión, false en caso contrario
  Future<bool> hasInternetConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      // Verifica si hay conexión a través de WiFi o datos móviles
      return results.any((result) => result != ConnectivityResult.none);
    } catch (e) {

      return false;
    }
  }

  /// Verifica la conectividad y lanza una excepción si no hay conexión a Internet
  /// Esta función debe ser llamada antes de realizar cualquier solicitud a la API
  Future<void> checkConnectivity() async {
    if (!await hasInternetConnection()) {
      throw ApiException('Por favor, verifica tu conexión a internet.');
    }
  }
  
  /// Muestra un SnackBar con un mensaje de error de conectividad que permanece hasta que hay conexión
  void showConnectivityError(BuildContext context) {
    SnackBarHelper.showServerError(
      context, 
      ErrorConstants.errorNoInternet,
      duration: const Duration(days: 1) // Virtualmente infinito
    );
  }
}
