String? emailValidator(String? value) {
  if (!value!.contains('@') || !value.contains('.')) {
    return 'Por favor ingrese un correo válido';
  }
  if (value.contains(' ')) {
    return 'El correo no puede contener espacios en blanco';
  }
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'El campo nombre es obligatorio';
  }
  if (value.length < 2 || value.length > 50) {
    return 'El nombre debe rondar entre 2 y 50 caracteres';
  }
  if (!value.contains(RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$"))) {
    return 'El nombre solo debe contener letras';
  }
  return null;
}

String? addressValidator(String? value) {
  if (value!.length < 5 || value.length > 100) {
    return 'La dirección debe rondar entre 5 y 100 caracteres';
  }
  return null;
}

String? birthdayValidator(String? value) {
  final now = DateTime.now();

  if (!value!.contains(RegExp(r'^\d{4}-\d{2}-\d{2}$'))) {
    return 'Ingrese una fecha válida en el formato YYYY-MM-DD';
  }
  if (DateTime.parse(value).isAfter(DateTime.now()) ||
      DateTime.parse(value)
          .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
    return 'La fecha debe ser anterior';
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value!.length < 8) {
    return 'La contraseña debe tener al menos 8 caracteres';
  }
  if (!RegExp(r'(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}')
      .hasMatch(value)) {
    return 'debe tener al menos una mayúscula, numero y caracter especial';
  }
  return null;
}

String? confirmPasswordValidator(String? value, String password) {
  if (value != null && value != password) {
    return 'Debe coincidir con su contraseña';
  }
  return null;
}

String? phoneNumberValidator(String? value) {
  if (value!.length < 10 || value.length > 15) {
    return 'N° Teléfono debe tener entre 10 y 15 caracteres';
  }
  if (!value.contains(RegExp(r'^[0-9]+$'))) {
    return 'El N° Teléfono debe tener solo numeros';
  }
  return null;
}
