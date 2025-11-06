import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. IMPORTA LAS PANTALLAS CORRECTAS
import 'package:reconectate/features/auth/data/domain/presentation/screens/splash_screen.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/login_screen.dart';
// ¡ESTA ES LA IMPORTACIÓN CORRECTA PARA EL REGISTRO!
import 'package:reconectate/features/auth/data/domain/presentation/screens/register_screen.dart';
import 'package:reconectate/features/profile/presentation/screens/Codigo_ver.dart';
import 'package:reconectate/features/profile/presentation/screens/editarPerfil.dart';
import 'package:reconectate/features/profile/presentation/screens/Perfil.dart';
// ¡IMPORTA EL AUTHGATE Y EL HOME!
import 'package:reconectate/navigation/auth_gate.dart';
import 'package:reconectate/features/home_courses/data/domain/presentation/screens/home.dart';


// 3. El Provider de Riverpod (sin cambios)
final appRouterProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    initialLocation: '/', // La ruta inicial de la app
    debugLogDiagnostics: true,

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
        path: '/registre',
        name: 'Crear_cuenta',
        // ¡LA CORRECCIÓN CRÍTICA!
        // Apunta al widget correcto: RegisterScreen
        builder: (context, state) => const RegisterScreen(),

      ),
      GoRoute(
        path: '/verific',
        name: 'Codigo_ver',
        builder: (context, state) => const VerificationScreen(), // Corregido el nombre del widget
      ),
      GoRoute(path: '/editarPerfil',
        name: 'ActualizarUsuario',
        builder: (context,state) => const editarPerfil(),
      ),
      GoRoute(path: '/perfil',
        name: 'perfil',
        builder: (context,state)=> const Perfil(),
      ),

      // ¡NUEVO! Ruta para el Home (necesaria para el AuthGate)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
});