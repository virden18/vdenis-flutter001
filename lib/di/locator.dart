import 'package:vdenis/api/service/auth_service.dart';
import 'package:vdenis/api/service/categoria_service.dart';
import 'package:vdenis/api/service/comentario_service.dart';
import 'package:vdenis/api/service/noticia_service.dart';
import 'package:vdenis/api/service/preferencia_service.dart';
import 'package:vdenis/api/service/reporte_service.dart';
import 'package:vdenis/api/service/tareas_service.dart';
import 'package:vdenis/bloc/reporte/reporte_bloc.dart';
import 'package:vdenis/core/services/shared_preferences_service.dart';
import 'package:vdenis/data/auth_repository.dart';
import 'package:vdenis/data/categoria_repository.dart';
import 'package:vdenis/data/comentario_repository.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/data/preferencia_repository.dart';
import 'package:vdenis/data/reporte_repository.dart';
import 'package:vdenis/core/services/connectivity_service.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdenis/data/tarea_repository.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  // Registrar primero los servicios básicos
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesService());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Servicios de API
  di.registerLazySingleton<TareaService>(() => TareaService());
  di.registerLazySingleton<ComentarioService>(() => ComentarioService());
  di.registerLazySingleton<AuthService>(() => AuthService());
  di.registerLazySingleton<CategoriaService>(() => CategoriaService());
  di.registerLazySingleton<NoticiaService>(() => NoticiaService());
  di.registerLazySingleton<ReporteService>(() => ReporteService());
  di.registerLazySingleton<PreferenciaService>(() => PreferenciaService());

  // Repositorios
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<TareasRepository>(() => TareasRepository());

  // BLoCs
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
}
