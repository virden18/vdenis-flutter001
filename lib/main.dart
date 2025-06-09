import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vdenis/bloc/auth/auth_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_bloc.dart';
import 'package:vdenis/bloc/preferencia/preferencia_bloc.dart';
import 'package:vdenis/bloc/reporte/reporte_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_bloc.dart';
import 'package:vdenis/core/services/shared_preferences_service.dart';
import 'package:vdenis/di/locator.dart';
import 'package:vdenis/bloc/contador/contador_bloc.dart';
import 'package:vdenis/bloc/connectivity/connectivity_bloc.dart';
import 'package:vdenis/components/connectivity_wrapper.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:vdenis/theme/theme.dart';
import 'package:vdenis/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';
import 'package:vdenis/bloc/noticia/noticia_bloc.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: ".env");
    
    await initLocator();
    await SharedPreferencesService().init();

    final secureStorage = di<SecureStorageService>();
    await secureStorage.clearJwt();
    await secureStorage.clearUserEmail();

    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error durante la inicialización: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error al iniciar la aplicación: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContadorBloc>(create: (context) => ContadorBloc()),
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()),
        BlocProvider(create: (context) => ComentarioBloc()),
        BlocProvider(create: (context) => ReporteBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider<NoticiaBloc>(create: (context) => NoticiaBloc()),
        BlocProvider<TareaBloc>(create: (context) => TareaBloc(), lazy: false),
        BlocProvider<PreferenciaBloc>(create: (context) => PreferenciaBloc()),
      ],
      child: MaterialApp(
        title: 'VDenis App Demo',
        theme: AppTheme.bootcampTheme,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
        home: const LoginScreen(),
      ),
    );
  }
}