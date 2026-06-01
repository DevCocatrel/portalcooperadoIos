import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/validators.dart';
import 'package:cocatrel/pages/change_password/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final changePasswordController = ChangePasswordController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: changePasswordController,
      child: DefaultScaffoldWidget(
        appBar: const ProfileAppBar(
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('Alterar senha'),
                const SizedBox(height: 16),
                DefaultCardWidget(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primaryDark,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sugestões',
                            style: AppFonts.title.copyWith(
                              color: AppColors.primaryDark,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Evite o uso de senhas genéricas, se possível use letras, números e caracteres especiais para reforçar a sua senha!',
                        style: AppFonts.text.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                DefaultCardWidget(
                  child: Consumer<ChangePasswordController>(
                      builder: (context, controller, _) {
                    return Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.newPasswordTextController,
                            obscureText: controller.obscureNewPassword,
                            decoration: InputDecoration(
                              labelText: 'Nova senha',
                              suffixIcon: IconButton(
                                onPressed: controller.changeObscureNewPassword,
                                icon: SvgPicture.asset(
                                  AppAssets.visibility,
                                ),
                              ),
                            ),
                            onEditingComplete:
                                controller.confirmPasswordFocus.requestFocus,
                            validator: passwordValidator,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller:
                                controller.confirmPasswordTextController,
                            obscureText: controller.obscureConfirmPassword,
                            focusNode: controller.confirmPasswordFocus,
                            decoration: InputDecoration(
                              labelText: 'Repita a nova senha',
                              suffixIcon: IconButton(
                                onPressed:
                                    controller.changeObscureConfirmPassword,
                                icon: SvgPicture.asset(
                                  AppAssets.visibility,
                                ),
                              ),
                            ),
                            validator: (value) => confirmPasswordValidator(
                                value,
                                controller.newPasswordTextController.text),
                          ),
                          const SizedBox(height: 16),
                          Consumer<ChangePasswordController>(
                              builder: (context, controller, _) {
                            return ElevatedButton(
                              onPressed: () {
                                controller.changePassword(context);
                                FocusScope.of(context).unfocus();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Salvar',
                                    style: TextStyle(
                                      color: AppColors.buttonTextLight,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  controller.loadingChangePassword
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.arrow_forward_rounded)
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
