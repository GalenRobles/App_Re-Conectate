import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Para navegar a la siguiente pantalla
import 'package:reconectate/app/theme/app_colors.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

// 1. Añadimos 'TickerProviderStateMixin'
// Esto es necesario para que el AnimationController funcione.
class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {

  // 2. Declaramos el controlador de animación
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // 3. Inicializamos el controlador
    _controller = AnimationController(
      vsync: this, // Le decimos que use el TickerProvider de esta clase
      duration: const Duration(seconds: 3), // La duración total (3 segundos)
    );

    // 4. Añadimos un listener que llama a setState() para redibujar
    //    la barra de progreso en cada 'tick' de la animación.
    _controller.addListener(() {
      setState(() {}); // Esto redibuja el LinearProgressIndicator
    });

    // 5. Iniciamos la animación. Cuando se complete, navegamos.
    _controller.forward().whenComplete(() {
      // Esta función se llama automáticamente cuando la animación llega al 100%
      _navigateToNextScreen();
    });
  }

  // La lógica de navegación ahora está separada
  void _navigateToNextScreen() {
    // Verificamos que el widget todavía esté "montado" (visible)
    // antes de intentar navegar, para evitar errores.
    if (mounted) {
      context.go('/login'); // Asegúrate que tu router tenga la ruta '/login'
    }
  }

  @override
  void dispose() {
    // 6. ¡Muy importante! Debemos descartar el controlador
    // cuando el widget se destruya para liberar memoria.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos los temas de texto y colores
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Tu logo (sin cambios)
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
              const SizedBox(height: 24),

              // 2. El nombre de tu app (sin cambios)
              Text(
                'RE-CONECTATE',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 48),

              // 3. ¡LA BARRA DE PROGRESO ACTUALIZADA!
              LinearProgressIndicator(
                // 7. El 'value' (de 0.0 a 1.0) ahora está
                //    vinculado al valor de nuestro controlador.
                value: _controller.value,

                // Lee el color amarillo (EFC760) desde el tema
                color: AppColors.primaryYellow,

                // Lee el fondo de la barra (DCD9D1) desde el tema
                backgroundColor: theme.colorScheme.surfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

