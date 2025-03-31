class AuthService {
  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      print('AuthService: Credenciales inválidas');
      throw Exception('El usuario y la contraseña no pueden estar vacíos');
    } else {
      // Simula una llamada a un servidor para autenticar al usuario
      print('AuthService: Attempting login');
      print('Username: $username');
      print('Password: $password');
      // Simula una respuesta del servidor
      return;
    }
    
  }
}