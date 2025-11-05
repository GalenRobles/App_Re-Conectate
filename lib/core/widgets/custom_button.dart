import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  /// El texto que se mostrará dentro del botón.
  final String text;

  /// La función que se ejecutará al presionar el botón.
  // ¡CORRECCIÓN CLAVE! Ahora acepta 'VoidCallback?' (una función o null).
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    // SEGUNDA CORRECCIÓN: Al ser opcional, NO puede ser 'required'
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // El widget ElevatedButton automáticamente se deshabilita
    // y cambia de color si 'onPressed' es 'null'.
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}