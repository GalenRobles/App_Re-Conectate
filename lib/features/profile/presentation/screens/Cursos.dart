import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:reconectate/app/theme/app_colors.dart';

class MisCursosView extends StatefulWidget {
  const MisCursosView({super.key});

  @override
  State<MisCursosView> createState() => _MisCursosViewState();
}

class _MisCursosViewState extends State<MisCursosView>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: child,
              );
            },
            child: const Icon(Icons.settings,
                size: 80, color: AppColors.primaryRed),
          ),
          const SizedBox(height: 20),
          const Text(
            'Próximamente...',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Estamos preparando tus cursos personalizados.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
