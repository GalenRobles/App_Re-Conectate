import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/managers/AuthStateManager.dart';
// Asegúrate de que esta ruta sea correcta para tu AuthNotifier
import 'auth_login_notifier.dart';


// ----------------------------------------------------------------------
// 1. PROVIDERS BÁSICOS (Tú ya los tenías)
// ----------------------------------------------------------------------

// 1.1. Provider del Manager: Provee la instancia de AuthStateManager
final authStateManagerProvider = Provider<AuthStateManager>((ref) {
  return AuthStateManager();
});

// 1.2. StreamProvider: Escucha los cambios de estado (Usado por AuthGate)
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authManager = ref.watch(authStateManagerProvider);
  return authManager.userAuthStateChanges;
});

// 1.3. Provider de Logout: Expone la función de cerrar sesión
final signOutProvider = Provider<Future<void> Function()>(
      (ref) {
    final authManager = ref.read(authStateManagerProvider);
    return authManager.signOut;
  },
);

// ----------------------------------------------------------------------
// 2. PROVIDER DEL NOTIFIER (NUEVO - Para Login y Registro)
// ----------------------------------------------------------------------

// Este provider es el que Lira usará para llamar a signIn y signUp.
final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});