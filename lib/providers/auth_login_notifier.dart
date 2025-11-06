import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Quité la importación de AuthStateManager para simplificar las dependencias.

// ------------------------------------------------------------
// 1. CONSTANTE DE SEGURIDAD (Se deja vacía, ya que la app Android lo maneja)
// ------------------------------------------------------------
const String GOOGLE_WEB_CLIENT_ID = "";

// ----------------------------------------------------------------------
// 2. EL NOTIFIER (Manejador de Lógica y Estado de Carga)
// ----------------------------------------------------------------------
class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  final _auth = FirebaseAuth.instance;

  // ------------------------------------------------------------
  // A) LOGIN CON EMAIL Y CONTRASEÑA
  // ------------------------------------------------------------
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    } finally {
      state = false;
    }
  }

  // ------------------------------------------------------------
  // B) REGISTRO CON EMAIL Y CONTRASEÑA (CRÍTICO)
  // ------------------------------------------------------------
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = true;

    // **DEBUG-PUNTO CLAVE:** Ver si se llega al servicio
    print('DEBUG-AUTH-SERVICE: Llamando a Firebase con email: $email');

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('DEBUG-AUTH-SERVICE: Autenticación exitosa en el servicio!');
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } finally {
      state = false;
    }
  }

  // ------------------------------------------------------------
  // C) LOGIN CON GOOGLE (SIMPLIFICADO)
  // ------------------------------------------------------------
  Future<void> signInWithGoogle() async {
    state = true;
    try {
      // Usamos la inicialización simple para que use el google-services.json
      final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // ------------------------------------------------------------
  // D) RECUPERACIÓN DE CONTRASENA (Si la llegas a necesitar)
  // ------------------------------------------------------------
  Future<void> sendPasswordResetEmail({required String email}) async {
    state = true;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    } finally {
      state = false;
    }
  }
}

// ----------------------------------------------------------------------
// 3. CREACIÓN DEL PROVIDER (Se asume que está en auth_providers.dart)
// ----------------------------------------------------------------------
// Nota: Esta línea debe estar en auth_providers.dart, no aquí, para evitar conflictos.
// final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
//   return AuthNotifier();
// });