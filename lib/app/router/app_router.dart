import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. Importa el "Shell" o contenedor principal (si ya lo tienes)
import 'package:app/app/shell/main_navigation_shell.dart';

// 2. Importa las pantallas necesarias
import 'package:app/features/auth/presentation/screens/splash_screen.dart';
import 'package:app/features/auth/presentation/screens/login_screen.dart';
import 'package:app/features/auth/presentation/screens/register_screen.dart';
import 'package:app/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:app/features/profile/presentation/screens/editarPerfil.dart';
import 'package:app/features/profile/presentation/screens/Perfil.dart';
// ¡IMPORTA EL AUTHGATE Y EL HOME!
import 'package:app/navigation/auth_gate.dart';
import 'package:app/features/home_courses/presentation/screens/home.dart';
import 'package:app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:app/features/home_courses/presentation/screens/Cursos.dart';

// 3. El Provider de Riverpod que "provee" el router a la app
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

      // --- B. SHELL CON BOTTOM NAV BAR Y ANIMACIONES ---
      ShellRoute(
        builder: (context, state, child) => MainNavigationShell(child: child),
        routes: [
          _animatedRoute(
            path: '/home',
            name: 'home',
            child: const HomeView(),
          ),
          _animatedRoute(
            path: '/cursos',
            name: 'cursos',
            child: const MisCursosView(),
          ),
          _animatedRoute(
            path: '/perfil',
            name: 'perfil',
            child: const Perfil(),
            subroutes: [
              GoRoute(
                path: 'editar',
                name: 'editarPerfil',
                builder: (context, state) => const EditarPerfil(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// 🔹 Función auxiliar para crear rutas con animación de transición
GoRoute _animatedRoute({
  required String path,
  required String name,
  required Widget child,
  List<GoRoute> subroutes = const [],
}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // 👇 Animación combinada: fade + slide
        const beginOffset = Offset(0.1, 0);
        const endOffset = Offset.zero;
        final tween = Tween(begin: beginOffset, end: endOffset)
            .chain(CurveTween(curve: Curves.easeInOut));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    ),
    routes: subroutes,
  );
}
