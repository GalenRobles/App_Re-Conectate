import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ------------------------------------------------------------
// 1. CONSTANTE (vacía en Android; iOS sí la requiere)
// ------------------------------------------------------------
const String GOOGLE_WEB_CLIENT_ID = "";

// ------------------------------------------------------------
// 2. AUTH NOTIFIER (Manejador de inicio de sesión + estado)
// ------------------------------------------------------------
class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ------------------------------------------------------------
  // A) LOGIN CON EMAIL Y CONTRASEÑA
  // ------------------------------------------------------------
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(const Duration(seconds: 10));
    } on FirebaseAuthException {
      rethrow;
    } on TimeoutException {
      throw Exception(
          'El inicio de sesión tardó demasiado (Timeout). Revisa tu conexión.');
    } finally {
      state = false;
    }
  }

  // ------------------------------------------------------------
  // B) REGISTRO CON EMAIL Y CONTRASEÑA
  // ------------------------------------------------------------
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = true;

    print('DEBUG-AUTH: Intentando registrar usuario $email');

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('DEBUG-AUTH: Registro completado');
      return credential;
    } on FirebaseAuthException {
      rethrow;
    } finally {
      state = false;
    }
  }

  // ------------------------------------------------------------
  // C) LOGIN CON GOOGLE + CREACIÓN DE PERFIL EN FIRESTORE
  // ------------------------------------------------------------
  Future<void> signInWithGoogle() async {
    state = true;

    try {
      final GoogleSignIn google = GoogleSignIn(scopes: [
        'email',
        'profile',
      ]);

      final GoogleSignInAccount? googleUser = await google.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) return;

      // -----------------------------------------------------------------
      // 🔥 PASO EXTRA: Crear perfil en Firestore si no existe
      // -----------------------------------------------------------------
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        final displayName = googleUser.displayName ?? "";
        final splitted = displayName.split(" ");

        final nombre = splitted.isNotEmpty ? splitted.first : "";
        final apellido =
        splitted.length > 1 ? splitted.sublist(1).join(" ") : "";

        await userDoc.set({
          'nombre': nombre,
          'apellido': apellido,
          'email': googleUser.email,
          'photoUrl': googleUser.photoUrl ?? "",
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("DEBUG-AUTH: Perfil creado automáticamente para usuario Google.");
      } else {
        print("DEBUG-AUTH: Perfil ya existía.");
      }

    } on FirebaseAuthException {
      rethrow;
    } finally {
      state = false;
    }
  }

  // ------------------------------------------------------------
  // D) RECUPERAR CONTRASEÑA
  // ------------------------------------------------------------
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
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
