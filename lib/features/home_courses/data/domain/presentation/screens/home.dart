// Archivo: lib/features/home_courses/data/domain/presentation/screens/home.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importa tu provider de logout que creaste:
import '../../../../../../providers/auth_providers.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Obtiene la función de cerrar sesión
    final signOut = ref.read(signOutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Bienvenido, Reconectate!'),
        backgroundColor: Colors.indigo,
        actions: [
          // 2. Botón de Logout (llama al provider)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Llama a la función de Firebase Auth
              await signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Estás logueado. ¡Éxito en la arquitectura!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}