import 'package:intl/intl.dart';

String brazilianFormatDouble(double value) {
  final format =
      NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);

  return format.format(value);
}
