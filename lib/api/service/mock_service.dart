import 'dart:async';

class MockService {
  Future<void> login(String username, String password) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simula el envío de credenciales al servidor
    //print('MockService: Login attempt');
    //print('Username: $username');
    //print('Password: $password');

    // Simula una respuesta exitosa
    return;
  }
}