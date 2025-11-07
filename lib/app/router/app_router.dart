import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. IMPORTA LAS PANTALLAS CORRECTAS
import 'package:reconectate/features/auth/data/domain/presentation/screens/splash_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/login_screen.dart';
// ¡ESTA ES LA IMPORTACIÓN CORRECTA PARA EL REGISTRO!
import 'package:reconectate/features/auth/data/domain/presentation/screens/register_screen.dart';
import 'package:reconectate/features/profile/presentation/screens/Crear_cuenta.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/otp_verification_screen.dart';
import 'package:reconectate/features/profile/presentation/screens/editarPerfil.dart';
import 'package:reconectate/features/profile/presentation/screens/Perfil.dart';
// ¡IMPORTA EL AUTHGATE Y EL HOME!
import 'package:reconectate/navigation/auth_gate.dart';
import 'package:reconectate/features/home_courses/data/domain/presentation/screens/home.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/forgot_password_screen.dart';


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
        // ¡CORRECCIÓN DE ARQUITECTURA!
        // La Splash screen no debe ir a /login, debe ir al AuthGate.
        // El AuthGate decidirá si va a Home o Login.
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
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
          // Obtenemos el email pasado desde el registro (debe ser un String)
          final email = state.extra as String?;

          // 🚨 CORRECCIÓN 2: Usamos OtpVerificationScreen (la clase existente)
          // Si el email es nulo, volvemos a registro.
          if (email == null) {
            return const RegistrationScreen();
          }

          // Si el email existe, lo pasamos al constructor
          return OtpVerificationScreen(email: email);
        },
      ),
      GoRoute(path: '/editarPerfil',
        name: 'ActualizarUsuario',
        builder: (context,state) => const EditarPerfil(),
      ),
      GoRoute(path: '/perfil',
        name: 'perfil',
        builder: (context,state)=> const Perfil(),
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
});