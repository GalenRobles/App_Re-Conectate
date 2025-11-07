import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // [LLAMADO POR LIRA]
  // Crea el documento inicial del perfil cuando se registra un usuario.
  // Función que crea el documento inicial del perfil al registrarse un usuario.
  Future<void> createUserProfile({ // <--- CAMBIO: Usamos Named Parameters
    required String userId,
    required String email,
    required String nombre, // <--- AÑADIDO: Para recibir el dato del formulario
    required String apellido, // <--- AÑADIDO: Para recibir el dato del formulario
  }) async {
    await _db.collection('users').doc(userId).set({
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(), // Opcional, pero buena práctica
    });
  }

  // [LLAMADO POR EDWIN]
  // Función que lee los datos del perfil para mostrarlos en Editar Perfil.
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