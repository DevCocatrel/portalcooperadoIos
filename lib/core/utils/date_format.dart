import 'package:intl/intl.dart';

String basicDateFormat(DateTime? date) {
  if (date != null) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  return '';
}
