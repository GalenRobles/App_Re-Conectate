import 'package:firebase_auth/firebase_auth.dart';

class AuthStateManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Este es el Stream que usarás para decidir si mostrar Login o Home.
  // Es el pilar de tu tarea de arquitectura de mañana.
  Stream<User?> get userAuthStateChanges => _auth.authStateChanges();

  // Si lo deseas, puedes añadir aquí un método simple de Logout.
  Future<void> signOut() {
    return _auth.signOut();
  }
}