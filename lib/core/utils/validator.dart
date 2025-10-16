class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es obligatorio.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, ingrese un correo electrónico válido.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria.';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio.';
    }
    return null;
  }

  // Nuevo validador genérico
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo $fieldName es obligatorio.';
    }
    return null;
  }
}
