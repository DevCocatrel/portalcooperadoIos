import 'package:cocatrel/common/widgets/appbar/go_back_app_bar.dart';
import 'package:cocatrel/common/widgets/button_loading/button_loading_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/validators.dart';
import 'package:cocatrel/pages/login_admin/login_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginAdminPage extends StatelessWidget {
  LoginAdminPage({super.key});

  final loginController = LoginAdminController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const GoBackAppBar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(16).copyWith(bottom: 0),
        child: ChangeNotifierProvider.value(
          value: loginController,
          child: SingleChildScrollView(
            child: Form(
              key: loginController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Acesso administrativo',
                    style: AppFonts.title,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: loginController.registrationTextController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Matrícula',
                    ),
                    validator: registrationValidator,
                    onEditingComplete: () {
                      loginController.userNameNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: loginController.userNameTextController,
                    focusNode: loginController.userNameNode,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                    ),
                    validator: userNameValidator,
                    onEditingComplete: () {
                      loginController.passwordNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<LoginAdminController>(
                      builder: (context, controller, _) {
                    return TextFormField(
                      controller: loginController.passwordTextController,
                      focusNode: loginController.passwordNode,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.changeObscurePassword();
                          },
                          icon: SvgPicture.asset(AppAssets.visibility),
                        ),
                      ),
                      validator: passwordValidator,
                      obscureText: controller.obscurePassword,
                    );
                  }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final value =
                          await loginController.loginWithRegistration(context);
                      if (value) {
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                            (_) => false,
                          );
                        }
                      }
                    },
                    child: Consumer<LoginAdminController>(
                        builder: (context, store, _) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Entrar'),
                          const SizedBox(width: 8),
                          store.loadingLogin
                              ? const ButtonLoadingWidget()
                              : const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.buttonTextLight,
                                )
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
