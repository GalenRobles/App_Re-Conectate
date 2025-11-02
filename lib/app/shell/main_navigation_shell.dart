import 'package:flutter/material.dart';

class MainNavigationShell extends StatelessWidget {
  // El ShellRoute nos pasará la pantalla (child) que debe mostrarse
  final Widget child;

  const MainNavigationShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Por ahora, solo mostramos el child.
    // TODO: Implementar el Scaffold con BottomNavigationBar aquí.
    return child;
  }
}