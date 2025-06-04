import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/data/auth_repository.dart';
import 'package:vdenis/bloc/auth/auth_event.dart';
import 'package:vdenis/bloc/auth/auth_state.dart';
import 'package:vdenis/data/preferencia_repository.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository= di<AuthRepository>(); 

  AuthBloc(): super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthFailure(ApiException('El usuario y la contraseña son obligatorios')));
        return;
      }
      
      final success = await _authRepository.login(
        event.email,
        event.password,
      );
      if (success) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthFailure(ApiException('Credenciales inválidas')));
      }
    } catch (e) {
      emit( AuthFailure(ApiException('Error al iniciar sesión')));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      di<PreferenciaRepository>().invalidarCache();      
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(ApiException('Error al cerrar sesión')));
    }
  }
}