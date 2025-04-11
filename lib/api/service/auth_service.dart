class AuthService {
  late String _authenticatedUser; // Propiedad privada para almacenar el usuario autenticado

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      print('AuthService: Credenciales inválidas');
      throw Exception('El usuario y la contraseña no pueden estar vacíos');
    } else {
      // Simula una llamada a un servidor para autenticar al usuario
      print('AuthService: Attempting login');
      print('Username: $username');
      print('Password: $password');

      // Simula una respuesta exitosa del servidor
      _authenticatedUser = username; // Guarda el usuario autenticado
      return;
    }
  }

  // Método para obtener el usuario autenticado
  String getAuthenticatedUser() {
    return _authenticatedUser;
  }
}