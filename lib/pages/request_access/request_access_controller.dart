import 'package:cocatrel/core/utils/launch_whatsapp.dart';
import 'package:flutter/material.dart';

class RequestAccessController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final registrationTextController = TextEditingController();
  final documentNumberTextController = TextEditingController();
  DateTime? date;

  final registrationFocus = FocusNode();
  final documentNumberFocus = FocusNode();

  bool? checkTerms = false;
  void changeCheckTerms(bool? value) {
    checkTerms = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  String? get dateFormatted {
    if (date != null) {
      final day = '${date!.day}'.padLeft(2, '0');
      final month = '${date!.month}'.padLeft(2, '0');

      return '$day/$month/${date!.year}';
    }
    return null;
  }

  void requestAccess(BuildContext context) {
    if (formKey.currentState!.validate()) {
      launchWhatsApp(context,
          content:
              '''Gostaria de solicitar o meu acesso ao App Cocatrel. Seguem as informações necessárias:

Nome Completo: ${nameTextController.text}
Matrícula: ${registrationTextController.text}
CPF: ${documentNumberTextController.text}
Data de Nascimento: $dateFormatted
''');
    }
  }
}
