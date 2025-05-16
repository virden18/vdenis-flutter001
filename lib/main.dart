import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importa flutter_bloc
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vdenis/bloc/connectivity/connectivity_bloc.dart';
import 'package:vdenis/di/locator.dart';
import 'package:vdenis/bloc/auth/auth_bloc.dart'; // Importa el AuthBloc
import 'package:vdenis/core/secure_storage.dart'; // Importa el servicio de almacenamiento seguro
import 'package:watch_it/watch_it.dart'; // Importa watch_it para usar di
import 'package:vdenis/components/connectivity_wrapper.dart'; // Importa el wrapper de conectividad
import 'package:vdenis/views/login_screen.dart';
import 'package:vdenis/bloc/contador/contador_bloc.dart'; // Importa el BLoC del contador

Future<void> main() async {
  // Carga las variables de entorno
  await dotenv.load(fileName: '.env');
  await initLocator();

  // Eliminar cualquier token guardado para forzar el inicio de sesión
  final secureStorage = di<SecureStorageService>();
  await secureStorage.clearJwt();
  await secureStorage.clearUserEmail();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContadorBloc()),
        BlocProvider(
          create: (context) => AuthBloc(),
        ), 
        BlocProvider(
          create: (context) => ConnectivityBloc(),
        ), // Bloc para gestionar la conectividad
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 254, 70, 85),
          ),
        ),
        builder: (context, child) {
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
        home: LoginScreen(), // Pantalla inicial
      ),
    );
  }
}