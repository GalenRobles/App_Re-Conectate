// Archivo: lib/navigation/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reconectate/features/home_courses/data/domain/presentation/screens/home.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/login_screen.dart';
import '../providers/auth_providers.dart'; // ¡Importante!

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el StreamProvider de Riverpod
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      // 1. ⏳ loading: El estado inicial (mientras Firebase verifica la sesión)
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      // 2. 🚨 error: Si hay un error con el stream (muy raro).
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error de autenticación: $err')),
      ),

      // 3. ✅ data: El estado final (user es nulo o tiene datos).
      data: (user) {
        // Si user no es nulo, el usuario está logueado.
        if (user != null) {
          return const HomeView();
        }

        // Si user es nulo, el usuario NO está logueado.
        return const LoginScreen();
      },
    );
  }
}