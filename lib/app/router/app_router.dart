import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. Importa el "Shell" o contenedor principal (si ya lo tienes)
import 'package:reconectate/app/shell/main_navigation_shell.dart';

// 2. Importa las pantallas necesarias
import 'package:reconectate/features/auth/data/domain/presentation/screens/splash_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/login_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/register_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/otp_verification_screen.dart';
import 'package:reconectate/features/profile/presentation/screens/editarPerfil.dart';
import 'package:reconectate/features/profile/presentation/screens/Perfil.dart';

// Pantallas principales
import 'package:reconectate/features/home_courses/data/domain/presentation/screens/home.dart';
import 'package:reconectate/features/profile/presentation/screens/Cursos.dart'; //

// AuthGate y otras
import 'package:reconectate/navigation/auth_gate.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/forgot_password_screen.dart';

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
    debugLogDiagnostics: true,
    routes: [
      // --- A. RUTAS DE AUTENTICACIÓN ---
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/forgotPassword',
        name: 'Recuperar_contra',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/registre',
        name: 'Crear_cuenta',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verific',
        name: 'Codigo_ver',
        builder: (context, state) {
          final email = state.extra as String?;
          if (email == null) return const RegisterScreen();
          return OtpVerificationScreen(email: email);
        },
      ),
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

      // --- B. RUTAS PRINCIPALES ---
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/cursos', // 👈 NUEVA RUTA
        name: 'cursos',
        builder: (context, state) => const MisCursosView(), // Pantalla con el engrane
      ),
    ],
  );
});
