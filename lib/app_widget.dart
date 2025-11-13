import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/app/router/app_router.dart';

// 1. IMPORTA TU NUEVO ARCHIVO DE TEMA
import 'package:app/app/theme/app_theme.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lee el router (como ya lo teníamos)
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Re-Conéctate',

      // 2. CONECTA TU TEMA
      // ¡Esta es la línea clave!
      theme: AppTheme.lightTheme,
    );
  }
}