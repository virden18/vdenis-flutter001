import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternetConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  Future<void> checkConnectivity() async {
    if (!await hasInternetConnection()) {
      throw ApiException(ConectividadConstantes.mensajeSinConexion,
        statusCode: 503
      );
    }
  }
}