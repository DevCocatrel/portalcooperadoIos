import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginAdminController extends ChangeNotifier {
  bool obscurePassword = true;

  final formKey = GlobalKey<FormState>();

  void changeObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  final registrationTextController = TextEditingController();
  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final registrationNode = FocusNode();
  final userNameNode = FocusNode();
  final passwordNode = FocusNode();

  bool loadingLogin = false;

  Future<bool> loginWithRegistration(BuildContext context) async {
    var auth = Provider.of<AuthProvider>(context, listen: false);

    if (formKey.currentState?.validate() ?? false) {
      if (loadingLogin) return false;
      loadingLogin = true;
      notifyListeners();

      final user = await LoginRepository.loginAsAdmin(
        registration: registrationTextController.text,
        userName: userNameTextController.text,
        password: passwordTextController.text,
      );

      if (user != null) {
        auth.setUser(user);
      }

      loadingLogin = false;
      notifyListeners();

      final hasUser = user != null;

      if (!hasUser) {
        showDefaultDialog(
          App.navigatorKey.currentContext!,
          title: 'Falha ao realizar o login',
          contentText: 'Verifique as credenciais inseridas e tente novamente',
        );
      }

      return hasUser;
    }
    return false;
  }
}
