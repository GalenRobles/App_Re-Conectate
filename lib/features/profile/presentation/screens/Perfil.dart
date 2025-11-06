import 'package:flutter/material.dart';
import 'package:reconectate/app/theme/app_colors.dart';
import 'editarPerfil.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado con ícono de usuario
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                color: AppColors.primaryYellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 16),

            // Texto del usuario
            const Text(
              'User1234567   Modelo: 4',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Botón Editar Perfil
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const editarPerfil()),
                );
              },
              child: const Text(
                'Editar Perfil',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Cuadro "Mejora tu plan"
            Container(
              width: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Mejora tu plan\n\nObtén acceso a información más detallada especialmente para ti, conoce mejor tu eneagrama y empieza a entenderte mejor.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botón Explorar curso completo
            ElevatedButton.icon(
              icon: const Icon(Icons.language, color: AppColors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              onPressed: () {},
              label: const Text(
                'Explorar el curso completo',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ),

            const Spacer(),

            // 🔧 Botón "Cerrar Sesión"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  // Aquí puedes agregar la lógica de logout
                },
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Barra inferior
            Container(
              height: 60,
              color: AppColors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavIcon(icon: Icons.home, label: 'Inicio'),
                  _NavIcon(icon: Icons.menu_book, label: 'Mis cursos'),
                  _NavIcon(icon: Icons.person, label: 'Perfil', active: true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavIcon({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            color: active ? AppColors.primaryRed : AppColors.textSecondary),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? AppColors.primaryRed : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
