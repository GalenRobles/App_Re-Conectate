import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Inicializa la instancia de Firestore (solo la usamos como referencia).
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // [LLAMADO POR LIRA]
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
    final docSnapshot = await _db.collection('users').doc(userId).get();

    // 2. Verificar si el documento existe
    if (docSnapshot.exists) {
      // 3. Devolver los datos como un mapa
      return docSnapshot.data();
    } else {
      // El perfil no existe (error en el flujo de registro)
      return null;
    }
  }

  // [LLAMADO POR EDWIN]
  // Función para actualizar cualquier campo del perfil (nombre, foto, etc.).
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    // Tarea de Edwin: Implementar lógica de actualización (update()).
    return Future.value();
  }


}