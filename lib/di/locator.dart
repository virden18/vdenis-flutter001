import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdenis/api/service/categoria_cache_service.dart';
import 'package:vdenis/core/connectivity_service.dart';
import 'package:vdenis/core/secure_storage.dart';
import 'package:vdenis/data/auth_repository.dart';
import 'package:vdenis/data/categoria_repository.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/data/preferencia_repository.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());
  di.registerLazySingleton<PreferenciaRepository>(
    () => PreferenciaRepository(),
  );
  // di.registerSingleton<ComentarioRepository>(ComentarioRepository());
  //di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  // Registramos el servicio de conectividad
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  // GetIt.instance.registerSingleton(ComentarioBloc());
  // // Cambiamos a registerFactory para generar una nueva instancia cada vez que sea solicitada
  // GetIt.instance.registerFactory(() => ReporteBloc());  
  di.registerSingleton<AuthRepository>(AuthRepository());

  // Registramos el servicio de caché de categorías como singleton
  di.registerLazySingleton<CategoryCacheService>(() => CategoryCacheService());
}
