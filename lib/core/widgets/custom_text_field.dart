// lib/core/widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos el tema de tu app para los colores y bordes
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        // Color de fondo basado en tu diseño (probablemente un gris claro o blanco)
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.1),
        // Bordes redondeados
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none, // Sin borde, como en tu diseño
        ),
        // Borde cuando hay un error (puedes ajustarlo a tu color de error)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        // Borde cuando está enfocado
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
        ),
      ),
    );
  }
}