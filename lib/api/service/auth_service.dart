import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/domain/login_request.dart';
import 'package:vdenis/domain/login_response.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class AuthService extends BaseService {
  AuthService() : super();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      dynamic data;
      final List<LoginRequest> usuariosTest = [
        const LoginRequest(username: 'profeltes', password: 'sodep'),
        const LoginRequest(username: 'monimoney', password: 'sodep'),
        const LoginRequest(username: 'sodep', password: 'sodep'),
        const LoginRequest(username: 'gricequeen', password: 'sodep'),
      ];

      // Verificar si las credenciales coinciden con algún usuario de prueba
      bool credencialesValidas = usuariosTest.any(
        (usuario) =>
            usuario.username == request.username &&
            usuario.password == request.password,
      );
       if (credencialesValidas) {
        data = await postUnauthorized(ApiConstantes.loginEndpoint, data: request.toJson());
      }

      if (data != null) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException(AppConstantes.errorAuthVacio);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException(WhereConstants.errorLogin);
      }
    }
  }
}
