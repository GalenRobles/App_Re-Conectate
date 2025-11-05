import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Asegúrate de que esta ruta sea correcta para tu AuthStateManager
import 'package:reconectate/managers/AuthStateManager.dart';

// ----------------------------------------------------------------------
// 1. EL NOTIFIER (Manejador de Lógica y Estado de Carga)
// ----------------------------------------------------------------------
class AuthNotifier extends StateNotifier<bool> {
  // El estado (state) es un simple booleano: true si está cargando, false si no.
  AuthNotifier() : super(false);

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  // ------------------------------------------------------------
  // A) LOGIN CON EMAIL Y CONTRASEÑA
  // ------------------------------------------------------------
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = true; // Activa el estado de carga
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Éxito: El AuthGate detecta el cambio automáticamente.
    } on FirebaseAuthException {
      // Usamos 'rethrow' para que la UI (LoginScreen) capture y muestre el error
      rethrow;
    } finally {
      state = false; // Desactiva el estado de carga
    }
  }

  // ------------------------------------------------------------
  // B) REGISTRO CON EMAIL Y CONTRASEÑA (TU TAREA DE HOY)
  // ------------------------------------------------------------
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      // Crea el usuario en Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Devolvemos el UserCredential.
      // Edwin DEBE usar esto para obtener el userId y crear el perfil en Firestore.
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } finally {
      state = false;
    }
  }

  // ------------------------------------------------------------
  // C) LOGIN CON GOOGLE
  // ------------------------------------------------------------
  Future<void> signInWithGoogle() async {
    state = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

    } on FirebaseAuthException {
      rethrow;
    } finally {
      state = false;
    }
  }
}

// ----------------------------------------------------------------------
// 2. CREACIÓN DEL PROVIDER
// ----------------------------------------------------------------------
// El proveedor que la UI usa para llamar a las funciones de login/registro.
final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});