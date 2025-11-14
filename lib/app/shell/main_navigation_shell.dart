import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/app/theme/app_colors.dart';

class MainNavigationShell extends StatelessWidget {
  final Widget child;

  const MainNavigationShell({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Detectar la ruta actual
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/home')) currentIndex = 0;
    else if (location.startsWith('/cursos')) currentIndex = 1;
    else if (location.startsWith('/perfil')) currentIndex = 2;

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/cursos');
              break;
            case 2:
              context.go('/perfil');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Mis Cursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
