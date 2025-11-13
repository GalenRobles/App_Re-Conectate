import 'package:flutter/material.dart';
import 'package:app/app/theme/app_colors.dart';

class MisCursosView extends StatelessWidget {
  const MisCursosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono animado
            const Icon(Icons.build_circle, size: 100, color: AppColors.primaryYellow),
            const SizedBox(height: 24),
            const Text(
              '🚧 En proceso...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Estamos preparando tus cursos, vuelve pronto.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
