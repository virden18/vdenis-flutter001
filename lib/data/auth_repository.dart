import 'package:vdenis/api/service/auth_service.dart';
import 'package:vdenis/data/preferencia_repository.dart';
import 'package:vdenis/domain/login_request.dart';
import 'package:vdenis/domain/login_response.dart';
import 'package:vdenis/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final SecureStorageService _secureStorage = SecureStorageService();  // Login user and store JWT token
  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ArgumentError('Error: Email and password cannot be empty.');
      }
      
      // Limpiar cualquier caché de preferencias previo al login para forzar la carga de las preferencias del nuevo usuario
      final preferenciaRepository = di<PreferenciaRepository>();
      preferenciaRepository.invalidarCache();
      
      final loginRequest = LoginRequest(
        username: email,
        password: password,
      );
      
      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);
      
      // Cargar preferencias del usuario recién logueado
      await preferenciaRepository.inicializarPreferenciasUsuario();
      
      return true;
    } catch (e) {
      return false;
    }
  }
    // Logout user
  Future<void> logout() async {
    // Limpiar la caché de preferencias antes de limpiar el token
    final preferenciaRepository = di<PreferenciaRepository>();
    preferenciaRepository.invalidarCache();
    
    // Limpiar tokens y datos de sesión
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