import 'package:dio/dio.dart';
import 'package:cocatrel/core/app/app.dart';
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

  Future<void> requestAccess(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        // Exibe um indicador de carregamento
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Chamada à nova API usando o userClient da classe App
        final response = await App.userClient.post(
          '/api/cocatrel/autenticacao/usuario/resetarsenhaportal', // Ajuste para o endpoint correto
          data: {
            'matricula': registrationTextController.text,
            'cpf': documentNumberTextController.text,
            'nome': nameTextController.text,
            'dataNascimento': dateFormatted,
          },
        );

        // Fecha o dialog de carregamento
        Navigator.pop(context);

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Solicitação enviada com sucesso! Foi encaminhado um e-mail com instruções para acesso.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
  // Fecha o dialog de carregamento caso ocorra erro
  Navigator.pop(context);

  String errorMessage = e.toString();

  // Se for um erro do Dio, extraímos a resposta detalhada do servidor se houver
  if (e is DioException && e.response?.data != null) {
    errorMessage = 'Erro ${e.response?.statusCode}: ${e.response?.data}';
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Erro ao solicitar acesso: $errorMessage'),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5), // Dá tempo de ler o erro completo
    ),
  );
}
    } else {
      print('--> Validação do formulário falhou!');
    }
  }
}
