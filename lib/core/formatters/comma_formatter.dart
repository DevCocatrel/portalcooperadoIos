import 'package:flutter/services.dart';

class CommaFormatter extends TextInputFormatter {
  // transform comma to dot
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final newText = newValue.text;
    final value = double.tryParse(newText.replaceAll(',', '.'));

    if (value == null) {
      return oldValue;
    }

    return newValue;
  }
}
