import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// --- Shell principal con BottomNavigationBar ---
import 'package:reconectate/app/shell/main_navigation_shell.dart';

// --- Pantallas de autenticación ---
import 'package:reconectate/features/auth/data/domain/presentation/screens/splash_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/login_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/register_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/otp_verification_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/forgot_password_screen.dart';

// --- Pantallas principales ---
import 'package:reconectate/features/home_courses/data/domain/presentation/screens/home.dart';
import 'package:reconectate/features/profile/presentation/screens/Cursos.dart';
import 'package:reconectate/features/profile/presentation/screens/Perfil.dart';
import 'package:reconectate/features/profile/presentation/screens/editarPerfil.dart';

// --- Control de sesión ---
import 'package:reconectate/navigation/auth_gate.dart';

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

// --- ROUTER CONFIG ---
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
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
