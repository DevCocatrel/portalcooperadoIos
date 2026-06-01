import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final newPasswordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  final confirmPasswordFocus = FocusNode();

  bool obscureNewPassword = true;
  void changeObscureNewPassword() {
    obscureNewPassword = !obscureNewPassword;
    notifyListeners();
  }

  bool obscureConfirmPassword = true;
  void changeObscureConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  bool loadingChangePassword = false;

  Future<void> changePassword(BuildContext context) async {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    loadingChangePassword = true;
    notifyListeners();
    try {
      if (formKey.currentState!.validate()) {
        final success = await UserRepository.changePassword(
          newPassword: newPasswordTextController.text,
          confirmPassword: confirmPasswordTextController.text,
          registration: auth.user?.registration ?? '',
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: success ? null : Colors.red,
              content: Text(
                success
                    ? 'Senha alterada com sucesso'
                    : "Não foi possível alterar sua senha",
              ),
            ),
          );
        }
        if (success) {
          newPasswordTextController.clear();
          confirmPasswordTextController.clear();
        }
      }
    } catch (_) {}
    loadingChangePassword = false;
    notifyListeners();
  }
}
