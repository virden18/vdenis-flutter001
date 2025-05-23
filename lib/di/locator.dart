import 'package:vdenis/bloc/reporte/reporte_bloc.dart';
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
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());  
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
  di.registerSingleton<TareasRepository>(TareasRepository());
}