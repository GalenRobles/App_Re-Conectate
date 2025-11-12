import 'package:flutter/material.dart';

/// 📦 CustomSnackBar — componente global para mostrar mensajes bonitos.
/// Usa colores distintos para éxito y error.
class CustomSnackBar {
  static void show(BuildContext context,
      {required String message, bool isError = false}) {
    final color = isError ? Colors.redAccent : Colors.green.shade600;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
