import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/managers/AuthStateManager.dart'; //
import 'auth_login_notifier.dart'; //
import 'package:reconectate/services/FirestoreService.dart'; //

// ----------------------------------------------------------------------
// 1. PROVIDERS BÁSICOS (Manejo de la Sesión y Logout)
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
// 2. PROVIDER DEL NOTIFIER (Login y Registro)
// ----------------------------------------------------------------------

final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

// 4. PROVIDER PARA RECUPERACIÓN DE CONTRASEÑA (Para la nueva UI)
final passwordResetProvider = Provider<Future<void> Function({required String email})>(
      (ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    return ({required String email}) => authNotifier.sendPasswordResetEmail(email: email);
  },
);

// ----------------------------------------------------------------------
// 5. PROVIDER DEL SERVICIO DE FIRESTORE (Para la Clase)
// ----------------------------------------------------------------------

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// ----------------------------------------------------------------------
// 6. PROVIDER DE PERFIL (CRÍTICO - Para cargar datos del usuario logueado)
// ----------------------------------------------------------------------

/// Provider que combina el estado de Auth con la lectura de Firestore.
/// Edwin debe consumir este provider en HomeView.
final profileStreamProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  // 1. Obtenemos el ID del usuario logueado del stream de Auth
  final authState = ref.watch(authStateChangesProvider);

  // 2. Accedemos al servicio de lectura
  final firestoreService = ref.read(firestoreServiceProvider);

  return authState.when(
    // 3. Si Auth está cargando, devolvemos un Stream que es nulo (loading state en la UI)
    loading: () => Stream.value(null),
    error: (err, stack) => Stream.error(err),

    // 4. Si el estado de Auth tiene datos definidos
    data: (user) {
      if (user == null) {
        return Stream.value(null); // Si no hay usuario (logout), el perfil es nulo
      }

      // 5. ¡LA CLAVE! Si hay usuario (éxito en el login), llamamos a la función de lectura.
      // Convertimos la Future (lectura única) en un Stream para que Riverpod lo escuche.
      return Stream.fromFuture(firestoreService.getUserProfile(user.uid));
    },
  );
});