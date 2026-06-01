import 'package:flutter/services.dart';

class PlateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove qualquer caractere que não seja letra ou número e converte para maiúsculas
    final text =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    String newText;

    if (text.length <= 3) {
      // Até três letras iniciais
      newText = text;
    } else if (text.length == 4) {
      // Formato do Mercosul: ABC1
      newText = text.substring(0, 3) + text.substring(3, 4);
    } else if (text.length == 5) {
      // Formato do Mercosul: ABC1D
      newText = text.substring(0, 3) + text.substring(3, 5);
    } else if (text.length == 6) {
      // Formato do Mercosul: ABC1D2
      newText = text.substring(0, 3) + text.substring(3, 6);
    } else if (text.length == 7) {
      if (RegExp(r'^[A-Z]{3}[0-9]{1}[A-Z]{1}[0-9]{2}$').hasMatch(text)) {
        // Padrão Mercosul: ABC1D23
        newText = text;
      } else {
        // Padrão antigo: ABC-1234
        newText = '${text.substring(0, 3)}-${text.substring(3, 7)}';
      }
    } else {
      if (newValue.text.length == 9 && newValue.text.contains('-')) {
        newText = newValue.text.substring(0, 8);
      } else {
        if (newValue.text.length == 8 && !newValue.text.contains('-')) {
          newText = newValue.text.substring(0, 7);
        } else {
          newText = text;
        }
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class QtddBagsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = '';

    // remove caracteres nao numéricos: 15.89 => 15
    for (int i = 0; i < newValue.text.length; i++) {
      final letter = newValue.text[i];
      final parse = int.tryParse(letter);
      if (parse != null) {
        text += letter;
      } else {
        break;
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
