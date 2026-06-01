String? registrationValidator(String? value) {
  if (value == null) return null;
  value = value.trim();

  bool isNumeric = value.runes.every((int rune) {
    var character = String.fromCharCode(rune);
    return character.contains(RegExp(r'[0-9]'));
  });

  if (value.isEmpty) {
    return 'Insira uma matrícula';
  } else if (!isNumeric) {
    return 'Insira uma matrícula válida';
  }

  return null;
}

String? userNameValidator(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'Insira o nome do usuário';
  } else if (value.length < 3) {
    return 'Insira um nome de usuário válido';
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'Insira uma senha';
  } else if (value.length < 3) {
    return 'Insira uma senha com pelo menos 3 caracteres';
  }

  return null;
}

String? newPasswordValidator(String? value, String oldPassword) {
  final validatePassword = passwordValidator(value);
  if (validatePassword != null) {
    return validatePassword;
  }

  if (value == oldPassword) {
    return 'A nova senha não pode ser igual a antiga';
  }

  return null;
}

String? confirmPasswordValidator(String? value, String newPassword) {
  final validatePassword = passwordValidator(value);
  if (validatePassword != null) {
    return validatePassword;
  }

  if (value != newPassword) {
    return 'As senhas não são iguais';
  }

  return null;
}

String? nameValidator(String? value) {
  if (value == null) return null;
  if (value.isEmpty) {
    return 'Insira seu nome';
  }
  value = value.trim();
  if (value.replaceAll(' ', '').length < 3 || !value.contains(' ')) {
    return 'Insira um nome válido';
  } else if (RegExp(r'\d').hasMatch(value)) {
    return 'Insira um nome válido';
  }

  return null;
}

String? documentValidator(String? value) {
  if (value == null) return null;
  final RegExp cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');
  if (cpfRegex.hasMatch(value)) {
    return null;
  }
  return 'Insira um CPF válido';
}

String? cnpjValidator(String? value) {
  RegExp regExp = RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$|^\d{14}$');
  if (regExp.hasMatch(value ?? '')) {
    return null;
  }
  return 'Insira um CNPJ válido';
}

String? dateValidator(String? value) {
  if (value == null) return null;
  final RegExp dataRegex =
      RegExp(r'^([0-2][0-9]|3[01])/(0[1-9]|1[0-2])/[0-9]{4}$');
  if (dataRegex.hasMatch(value)) {
    return null;
  }
  return 'Insira uma data válida';
}

String? phoneValidator(String? value) {
  if (value == null) return null;

  if (value.isEmpty) {
    return 'Insira um telefone';
  }

  RegExp regExp = RegExp(r'^(\(?\d{2}\)?\s?)?9\d{4}-?\d{4}$|^\d{11}$');

  if (!regExp.hasMatch(value)) {
    return 'Insira um telefone válido';
  }

  if (value.replaceAll(RegExp(r'[^0-9]'), '').length != 11) {
    return 'Insira um telefone válido';
  }

  return null;
}

String? plateValidator(String? value) {
  value = (value ?? '').replaceAll(' ', '');
  // LLL-####
  RegExp oldPlateRegExp = RegExp(r'^[A-Z]{3}-?\d{4}$');

  // LLL#L##
  RegExp newPlateRegExp = RegExp(r'^[A-Z]{3}\d[A-Z]\d{2}$');

  // Verifica se a placa corresponde a qualquer um dos formatos
  final isValid =
      oldPlateRegExp.hasMatch(value) || newPlateRegExp.hasMatch(value);

  if (isValid) return null;
  return 'Insira uma placa válida';
}

String? emailValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, digite um email';
  }

  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Digite um email válido';
  }
  return null;
}
