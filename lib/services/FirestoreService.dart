import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // [LLAMADO POR LIRA]
  // Crea el documento inicial del perfil cuando se registra un usuario.
  Future<void> createUserProfile(String userId, String email) async {
    await _db.collection('users').doc(userId).set({
      'email': email,
      'nombre': '',
      'apellido': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // [LLAMADO POR EDWIN]
  // Obtiene los datos del perfil del usuario.
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  // [LLAMADO POR EDWIN]
  // Actualiza cualquier campo del perfil (nombre, apellido, email, etc.)
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }
}
