import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. Importa el "Shell" o contenedor principal (¡Lo crearemos!)
import 'package:reconectate/app/shell/main_navigation_shell.dart';

// 2. Importa TODAS las pantallas que definimos
import 'package:reconectate/features/auth/data/domain/presentation/screens/splash_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/login_screen.dart';

// ruta temporal
//import '../../features/profile/prasentation/screens/Perfil.dart';



// 3. El Provider de Riverpod que "provee" el router a la app
final appRouterProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    initialLocation: '/', // La ruta inicial de la app
    debugLogDiagnostics: true, // Muestra logs en la consola, útil para depurar

    // --- RUTAS DE LA APP ---
    routes: [

      // --- A. Rutas de Autenticación (Sin barra de navegación) ---

      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),


    ],
  );
});