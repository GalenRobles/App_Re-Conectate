import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reconectate/app/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // índice actual (0 = home, 1 = cursos, 2 = perfil)

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: currentIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/cursos');
          if (index == 2) context.go('/perfil');
        },
        items: [
          _animatedItem(Icons.home, 'Inicio', 0),
          _animatedItem(Icons.menu_book, 'Mis cursos', 1),
          _animatedItem(Icons.person, 'Perfil', 2),
        ],
      ),
    );
  }

  /// 🔹 Función privada para animar cada ícono
  BottomNavigationBarItem _animatedItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      label: label,
      icon: AnimatedScale(
        scale: currentIndex == index ? 1.2 : 1.0, // el activo se agranda
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: Icon(
          icon,
          color: currentIndex == index
              ? AppColors.primaryRed
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}
