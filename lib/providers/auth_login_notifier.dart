import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Puedes quitar la importación de AuthStateManager si ya no la necesitas aquí.
// import 'package:reconectate/managers/AuthStateManager.dart';

// ------------------------------------------------------------
// 1. CONSTANTE DE SEGURIDAD (Necesitas el ID de Cliente Web)
// ------------------------------------------------------------
// Tarea: Sustituir "YOUR_WEB_CLIENT_ID" por el ID de cliente web
// que termina en .apps.googleusercontent.com
const String GOOGLE_WEB_CLIENT_ID = "621996917537-2heuh2i6e8l9sejk82fir6k53nmi9os8.apps.googleusercontent.com";

// ----------------------------------------------------------------------
// 2. EL NOTIFIER (Manejador de Lógica y Estado de Carga)
// ----------------------------------------------------------------------
class AuthNotifier extends StateNotifier<bool> {
  // El estado (state) es un simple booleano: true si está cargando, false si no.
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
  // B) REGISTRO CON EMAIL Y CONTRASEÑA (Para Lira y Edwin)
  // ------------------------------------------------------------
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential; // CLAVE: Devuelve las credenciales para Edwin
    } on FirebaseAuthException {
      rethrow;
    } finally {
      state = false;
    }
  }

  // ------------------------------------------------------------
  // C) LOGIN CON GOOGLE (CORREGIDO)
  // ------------------------------------------------------------
  Future<void> signInWithGoogle() async {
    state = true;
    try {
      // 1. Inicializa Google Sign-In con el Client ID (CRÍTICO)
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId: GOOGLE_WEB_CLIENT_ID,
      );

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // Cancelado

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

