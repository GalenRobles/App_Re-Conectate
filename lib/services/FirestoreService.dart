import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Inicializa la instancia de Firestore.
  // Esta es la forma correcta de acceder a la base de datos en toda la aplicación.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ------------------------------------------------------------
  // A) CREACIÓN DE PERFIL (TAREA DE REGISTRO)
  // ------------------------------------------------------------
  /// Crea el documento inicial del perfil al registrarse un usuario.
  /// Lira llama a esta función con los datos del formulario.
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String nombre,
    required String apellido,
  }) async {
    // La clave del documento es el ID de usuario de Firebase Auth
    await _db.collection('users').doc(userId).set({
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      // Usamos el timestamp del servidor, buena práctica para ordenar perfiles
      'createdAt': FieldValue.serverTimestamp(),
      'photoUrl': '', // Campo inicial para la foto (se actualiza con Storage)
    });
  }

  // ------------------------------------------------------------
  // B) LECTURA DE PERFIL (Tu Tarea - Desbloquea HomeView)
  // ------------------------------------------------------------
  /// Función que lee los datos del perfil y los devuelve como un Map.
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    // 1. Obtiene una "instantánea" del documento
    final docSnapshot = await _db.collection('users').doc(userId).get();

    // 2. Verifica si el documento existe
    if (docSnapshot.exists) {
      // 3. Devuelve los datos
      return docSnapshot.data();
    } else {
      // Perfil no encontrado (debería existir si el registro fue correcto)
      return null;
    }
  }

  // ------------------------------------------------------------
  // C) ACTUALIZACIÓN DE PERFIL (Tarea de Edwin - Edición)
  // ------------------------------------------------------------
  /// Función para actualizar cualquier campo del perfil (nombre, foto, etc.).
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    // Usamos 'update' para modificar solo los campos proporcionados en el 'data'
    // sin afectar el resto del documento.
    await _db.collection('users').doc(userId).update(data);
  }
}