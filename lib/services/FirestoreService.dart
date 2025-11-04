import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Inicializa la instancia de Firestore (solo la usamos como referencia).
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // [LLAMADO POR LIRA]
  // Función que crea el documento inicial del perfil al registrarse un usuario.
  Future<void> createUserProfile(String userId, String email) async {
    // TODO: Implementar lógica de escritura de datos (Tarea de Lira/Picazo para mañana).
    return Future.value();
  }
  // [LLAMADO POR EDWIN]
  // Función que lee los datos del perfil para mostrarlos en Editar Perfil.
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    // Tarea de Edwin: Implementar lógica de lectura (get()).
    return null;
  }

  // [LLAMADO POR EDWIN]
  // Función para actualizar cualquier campo del perfil (nombre, foto, etc.).
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    // Tarea de Edwin: Implementar lógica de actualización (update()).
    return Future.value();
  }
}