
import 'package:vdenis/api/service/auth_service.dart';
import 'package:vdenis/core/service/secure_storage_service.dart';
import 'package:vdenis/domain/login_request.dart';
import 'package:vdenis/domain/login_response.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Login user and store JWT token
  Future<bool> login(String email, String password) async {
    try {
      final loginRequest = LoginRequest(
        username: email,
        password: password,
      );

      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Logout user
  Future<void> logout() async {
    await _secureStorage.clearJwt();
    await _secureStorage.clearUserEmail();
  }
    // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    // Siempre retorna false para forzar la pantalla de login
    return false;
  }
  
  // Get current auth token
  Future<String?> getAuthToken() async {
    return await _secureStorage.getJwt();
  }
}