import 'package:cocatrel/common/widgets/appbar/login_app_bar.dart';
import 'package:cocatrel/common/widgets/button_loading/button_loading_widget.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/launch_whatsapp.dart';
import 'package:cocatrel/core/utils/validators.dart';
import 'package:cocatrel/pages/login/login_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: loginController,
      child: Scaffold(
        appBar: const LoginAppBar(),
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primaryColor,
        body: Container(
          height: double.maxFinite,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Text('Já possui cadastro?'),
                    const SizedBox(height: 16),
                    Form(
                      key: loginController.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller:
                                loginController.registrationTextController,
                            decoration:
                                const InputDecoration(labelText: 'Matrícula'),
                            onEditingComplete: () {
                              loginController.passwordFocus.requestFocus();
                            },
                            validator: registrationValidator,
                          ),
                          const SizedBox(height: 16),
                          Consumer<LoginController>(
                              builder: (context, controller, _) {
                            return TextFormField(
                              controller:
                                  loginController.passwordTextController,
                              focusNode: controller.passwordFocus,
                              obscureText: controller.obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                suffixIcon: IconButton(
                                  onPressed: controller.changeObscurePassword,
                                  icon: SvgPicture.asset(
                                    AppAssets.visibility,
                                  ),
                                ),
                              ),
                              validator: passwordValidator,
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: AppFonts.text,
                        children: [
                          const TextSpan(text: 'Esqueceu a sua senha? '),
                          TextSpan(
                            text: 'Recupere aqui',
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDefaultDialog(
                                  context,
                                  title: 'Recuperar senha',
                                  contentText:
                                      'Você será redirecionado para o WhatsApp da nossa central de atendimento e um de nossos agentes irá seguir com a recuperação da sua senha.',
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Fechar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await launchWhatsApp(context,
                                            content:
                                                'Olá, desejo solicitar a troca da minha senha');
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Atendimento'),
                                          SizedBox(width: 8),
                                          Icon(Icons.headset_mic)
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        loginController
                            .loginWithRegistration(context)
                            .then((value) {
                          if (value) {
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.home,
                                (_) => false,
                              );
                            }
                          }
                        });
                      },
                      child: Consumer<LoginController>(
                          builder: (context, controller, _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Entrar'),
                            const SizedBox(width: 8),
                            controller.loadingLogin
                                ? const ButtonLoadingWidget()
                                : const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: AppColors.buttonTextLight,
                                  )
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    const DividerWidget(),
                    const SizedBox(height: 16),
                    const Text('É cooperado e não tem um acesso?'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.requestAccess);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Solicitar acesso'),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.buttonTextLight,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 88, bottom: 32),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Armazéns',
                                    style: AppFonts.text.copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Baixar tabela de horários',
                                    style: AppFonts.text,
                                  ),
                                ],
                              ),
                            ),
                            Consumer<LoginController>(
                                builder: (context, controller, _) {
                              return InkWell(
                                onTap: () {
                                  controller.warehouseOpeningHoursFileDownload(
                                      context);
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: controller.loadingDownloadFile
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.file_download_outlined,
                                          color: AppColors.buttonTextLight,
                                        ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const DividerWidget(),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.termsOfUse);
                      },
                      child: Text(
                        'Termo de Uso e Politica de Privacidade',
                        style: AppFonts.text,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
