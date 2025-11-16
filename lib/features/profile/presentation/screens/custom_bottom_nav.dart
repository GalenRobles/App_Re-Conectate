import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/app/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryRed,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) context.go('/home');
        if (index == 1) context.go('/cursos');
        if (index == 2) context.go('/perfil');
      },
      items: [
        _item(Icons.home, 'Inicio', 0),
        _item(Icons.menu_book, 'Cursos', 1),
        _item(Icons.person, 'Perfil', 2),
      ],
    );
  }

  BottomNavigationBarItem _item(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: currentIndex == index ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
