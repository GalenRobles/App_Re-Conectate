import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:reconectate/app/theme/app_colors.dart';
import 'package:reconectate/features/profile/presentation/screens/Perfil.dart';
import 'package:reconectate/features/home_courses/data/domain/presentation/screens/home.dart';

class MisCursos extends StatefulWidget {
  const MisCursos({super.key});

  @override
  State<MisCursos> createState() => _MisCursosState();
}

class _MisCursosState extends State<MisCursos>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Controlador que hace girar el engrane
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

  void _navigateTo(String label) {
    if (label == 'Inicio') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    } else if (label == 'Mis cursos') {
      // ya estás aquí
    } else if (label == 'Perfil') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Perfil()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryYellow,
        title: const Text(
          'Mis Cursos',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ---------- CONTENIDO CENTRAL ----------
          Expanded(
            child: Center(
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
                    child: const Icon(
                      Icons.settings,
                      size: 80,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Próximamente...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Estamos preparando tus cursos personalizados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- BARRA INFERIOR ----------
          Container(
            height: 60,
            color: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavIcon(
                  icon: Icons.home,
                  label: 'Inicio',
                  onTap: _navigateTo,
                ),
                _NavIcon(
                  icon: Icons.menu_book,
                  label: 'Mis cursos',
                  active: true,
                  onTap: _navigateTo,
                ),
                _NavIcon(
                  icon: Icons.person,
                  label: 'Perfil',
                  onTap: _navigateTo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Function(String) onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(label),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? AppColors.primaryRed : AppColors.textSecondary,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? AppColors.primaryRed : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
