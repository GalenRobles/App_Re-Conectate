/// 📘 validators.dart
/// Funciones reutilizables para validar entradas de texto (nombre, correo, etc.)
library validators;

final _lettersOnly = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$");
final _repeatedLetters = RegExp(r'^(.)\1+$');

/// Lista pequeña de nombres comunes en español (para filtrar entradas irreales)
final _commonNames = {
  'ana', 'andrea', 'maria', 'jose', 'juan', 'edwin', 'luis', 'pedro',
  'miguel', 'carlos', 'alejandro', 'laura', 'paola', 'sofia', 'fernanda',
  'antonio', 'jesus', 'marco', 'gabriel', 'lucia', 'rosa', 'daniela',
  'jorge', 'ricardo', 'veronica', 'karla', 'raul', 'adriana'
};

/// Lista pequeña de apellidos comunes
final _commonLastNames = {
  'lopez', 'gonzalez', 'rodriguez', 'hernandez', 'martinez', 'garcia',
  'perez', 'sanchez', 'ramirez', 'flores', 'cruz', 'ruiz', 'torres',
  'diaz', 'mendoza', 'morales', 'vasquez', 'ramos', 'castro', 'ortega'
};

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

  final lower = trimmed.toLowerCase();

  // Nombres artificiales tipo "Aa Bb", "No", "Si"
  if (['si', 'no', 'aa', 'bb', 'cc', 'xx', 'zz'].contains(lower)) {
    return 'Por favor ingresa un nombre válido';
  }

  // Detecta si parece un nombre/apellido real
  final firstWord = words.first.toLowerCase();
  if (!_commonNames.contains(firstWord) && words.length == 1) {
    return 'Por favor ingresa un nombre real';
  }

  return null;
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

  final lower = trimmed.toLowerCase();
  if (!_commonLastNames.contains(lower) && words.length == 1) {
    return 'Por favor ingresa un apellido real';
  }

  return null;
}
