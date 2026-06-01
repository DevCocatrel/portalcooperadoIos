import 'package:cocatrel/core/utils/currency.dart';

String? maxNumberValidator(
  String? value,
  double maxValue, {
  bool useCurrencyFormatter = false,
}) {
  if (value == null || value.isEmpty) {
    return 'Informe um valor';
  }

  final number = double.tryParse(value);

  if (number == null) {
    return 'Informe um número válido';
  }

  if (number > maxValue) {
    if (useCurrencyFormatter) {
      return '${Currency.format(maxValue)} é o máximo';
    }

    return '$maxValue é o máximo';
  }

  return null;
}
