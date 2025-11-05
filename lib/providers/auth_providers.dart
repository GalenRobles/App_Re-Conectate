import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/managers/AuthStateManager.dart';
// Asegúrate de que la ruta a AuthStateManager sea correcta

// 1. Provider del Manager: Crea una instancia de tu AuthStateManager.
final authStateManagerProvider = Provider<AuthStateManager>((ref) {
  return AuthStateManager();
});

// 2. StreamProvider: Escucha los cambios de estado (El Stream).
// Este Provider es consumido por el AuthGate.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authManager = ref.watch(authStateManagerProvider);
  return authManager.userAuthStateChanges;
});

// 3. Provider de Logout: Expone la función de cerrar sesión a la UI.
final signOutProvider = Provider<Future<void> Function()>(
      (ref) {
    final authManager = ref.read(authStateManagerProvider);
    return authManager.signOut;
  },
);