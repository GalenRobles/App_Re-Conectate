import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/profile/presentation/screens/custom_bottom_nav.dart';

class MainNavigationShell extends StatelessWidget {
  final Widget child;

  const MainNavigationShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/home')) currentIndex = 0;
    else if (location.startsWith('/cursos')) currentIndex = 1;
    else if (location.startsWith('/perfil')) currentIndex = 2;

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: currentIndex),
    );
  }
}
