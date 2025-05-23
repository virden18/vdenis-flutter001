import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdenis/api/service/categoria_cache_service.dart';
import 'package:vdenis/bloc/comentarios/comentario_bloc.dart';
import 'package:vdenis/bloc/reporte/reporte_bloc.dart';
import 'package:vdenis/core/service/connectivity_service.dart';
import 'package:vdenis/core/service/secure_storage_service.dart';
import 'package:vdenis/data/auth_repository.dart';
import 'package:vdenis/data/categoria_repository.dart';
import 'package:vdenis/data/comentario_repository.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/data/preferencia_repository.dart';
import 'package:vdenis/data/reporte_repository.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());
  di.registerSingleton<ComentarioRepository>(ComentarioRepository());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  GetIt.instance.registerSingleton(ComentarioBloc());
  GetIt.instance.registerFactory(() => ReporteBloc());  
  di.registerSingleton<AuthRepository>(AuthRepository());
  di.registerLazySingleton<CategoryCacheService>(() => CategoryCacheService());
}
