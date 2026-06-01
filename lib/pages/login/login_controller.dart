import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/app/app_config.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/repositories/file_download_repository.dart';
import 'package:cocatrel/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginController extends ChangeNotifier {
  bool obscurePassword = true;

  final formKey = GlobalKey<FormState>();

  void changeObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  final registrationTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final passwordFocus = FocusNode();

  bool loadingLogin = false;

  Future<bool> loginWithRegistration(BuildContext context) async {
    var auth = Provider.of<AuthProvider>(context, listen: false);

    if (formKey.currentState?.validate() ?? false) {
      if (loadingLogin) return false;
      loadingLogin = true;
      notifyListeners();

      final user = await LoginRepository.login(
        registrationTextController.text,
        passwordTextController.text,
      );

      if (user?.token != null) {
        auth.setUser(user);
      }

      loadingLogin = false;
      notifyListeners();

      final hasToken = user?.token != null;

      if (!hasToken) {
        showDefaultDialog(
          App.navigatorKey.currentContext!,
          title: 'Falha ao realizar o login',
          contentText: 'Verifique as credenciais inseridas e tente novamente',
        );
      }

      return hasToken;
    }
    return false;
  }

  bool loadingDownloadFile = false;
  Future<void> warehouseOpeningHoursFileDownload(BuildContext context) async {
    loadingDownloadFile = true;
    notifyListeners();

    final binaryData = await FileDownloadRepository.downloadFileAsBinary(
        AppConfig.warehouseOpeningHoursLink);

    if (binaryData != null && context.mounted) {
      Navigator.of(context).pushNamed(AppRoutes.pdfPage, arguments: {
        'pdfData': binaryData,
        'title': 'Horário dos armazéns',
      });
    } else if (context.mounted) {
      errorSnackBar('Erro ao baixar o horários de armazéns');
    }

    loadingDownloadFile = false;
    notifyListeners();
  }
}
