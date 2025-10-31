import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Aún no los creamos, así que los dejamos comentados
// import 'package:ejemplo/app/router/app_router.dart';
// import 'package:ejemplo/app/theme/app_theme.dart';

// Usamos un ConsumerWidget en lugar de un StatelessWidget.
// Esto nos dará acceso a 'ref' para leer providers si lo necesitamos.
class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Aquí es donde conectaremos GoRouter más adelante
    // final router = ref.watch(appRouterProvider);

    return MaterialApp(
      // Por ahora, una pantalla temporal para verificar que todo funciona
      home: Scaffold(
        appBar: AppBar(title: const Text('Re-Conéctate')),
        body: const Center(child: Text('¡Proyecto Iniciado!')),
      ),

      // --- TAREAS PARA DESPUÉS ---
      // 1. Quitar el banner de "Debug"
      debugShowCheckedModeBanner: false,

      // 2. Título de la app (para el sistema operativo)
      title: 'Re-Conéctate',

      // 3. Conectar el tema de tu Figma
      // theme: AppTheme.lightTheme,

      // 4. Conectar el router (cuando quitemos 'home:')
      // routerConfig: router,
    );
  }
}