import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. Importa el "Shell" o contenedor principal (si ya lo tienes)
import 'package:reconectate/app/shell/main_navigation_shell.dart';

// 2. Importa las pantallas necesarias
import 'package:reconectate/features/auth/data/domain/presentation/screens/splash_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/login_screen.dart';
import 'package:reconectate/features/profile/presentation/screens/Crear_cuenta.dart';
import 'package:reconectate/features/profile/presentation/screens/Codigo_ver.dart';
import 'package:reconectate/features/profile/presentation/screens/editarPerfil.dart';
import 'package:reconectate/features/profile/presentation/screens/Perfil.dart';

// (Si tienes estas pantallas, asegúrate de importarlas)
import 'package:reconectate/features/home/presentation/screens/home.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Re-Conéctate',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3EDE0),
      ),
    );
  }
}

// --- Router de la app (Riverpod Provider) ---
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/', // Ruta inicial
    debugLogDiagnostics: true, // Muestra logs útiles en la consola
    routes: [

      // --- A. RUTAS DE AUTENTICACIÓN ---
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
      GoRoute(
        path: '/registre',
        name: 'Crear_cuenta',
        builder: (context, state) => const RegistrationApp(),
      ),
      GoRoute(
        path: '/verific',
        name: 'Codigo_ver',
        builder: (context, state) => const VerificationApp(),
      ),

      // --- B. RUTAS DEL PERFIL ---
      GoRoute(
        path: '/editarPerfil',
        name: 'ActualizarUsuario',
        builder: (context, state) => const EditarPerfil(),
      ),
      GoRoute(
        path: '/perfil',
        name: 'perfil',
        builder: (context, state) => const Perfil(),
      ),

      // --- C. RUTAS PRINCIPALES CON BARRA ---
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const home(),
      ),

    ],
  );
});
