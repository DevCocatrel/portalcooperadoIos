import 'dart:io';

import 'package:intl/intl.dart';

class Currency {
  static String format(double value) {
    var format = NumberFormat.currency(
      locale: Platform.localeName,
      decimalDigits: 2,
      customPattern: "¤ #,##0.00",
      symbol: "R\$",
    );

    return format.format(value);
  }

  static String basicFormat(double value) {
    NumberFormat formatoBR = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
      decimalDigits: 2,
    );

    String formatValue = formatoBR.format(value);

    return formatValue;
  }
}
