// features/auth/domain/entities/app_user.dart

import 'package:equatable/equatable.dart'; // Buen paquete para comparar objetos

class AppUser extends Equatable {
  final String uid;
  final String email;
  final String? displayName; // Puede ser nulo al registrarse

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [uid, email, displayName];
}