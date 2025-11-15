library validators;

final _lettersOnly = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$");
final _repeatedLetters = RegExp(r'^(.)\1+$');

String? validateName(String? value) {
  final trimmed = value?.trim() ?? "";

  if (trimmed.isEmpty) return 'Este campo es obligatorio';
  if (!_lettersOnly.hasMatch(trimmed)) return 'Solo se permiten letras y espacios';

  final words = trimmed.split(RegExp(r"\s+"));

  if (words.length > 3) return 'Demasiadas palabras para un nombre';

  for (final w in words) {
    if (w.length < 2) return 'Cada palabra debe tener al menos 2 letras';
    if (_repeatedLetters.hasMatch(w.toLowerCase())) return 'Nombre no válido';
  }

  return null; // <-- IMPORTANTE: ahora sí permite nombres normales
}

String? validateLastName(String? value) {
  final trimmed = value?.trim() ?? "";

  if (trimmed.isEmpty) return 'Este campo es obligatorio';
  if (!_lettersOnly.hasMatch(trimmed)) return 'Solo se permiten letras y espacios';

  final words = trimmed.split(RegExp(r"\s+"));
  if (words.length > 3) return 'Demasiadas palabras para un apellido';

  for (final w in words) {
    if (w.length < 2) return 'Cada palabra debe tener al menos 2 letras';
    if (_repeatedLetters.hasMatch(w.toLowerCase())) return 'Apellido no válido';
  }

  return null; // <-- MISMO AQUÍ
}
