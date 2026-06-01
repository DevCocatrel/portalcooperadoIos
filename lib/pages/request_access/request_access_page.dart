import 'package:cocatrel/common/widgets/appbar/go_back_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/constants.dart';
import 'package:cocatrel/core/utils/validators.dart';
import 'package:cocatrel/pages/request_access/request_access_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class RequestAccessPage extends StatelessWidget {
  RequestAccessPage({super.key});

  final requestAccessController = RequestAccessController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: requestAccessController,
      child: DefaultScaffoldWidget(
        appBar: const GoBackAppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: requestAccessController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Solicitar acesso'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: requestAccessController.nameTextController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: nameValidator,
                    onEditingComplete: () {
                      requestAccessController.registrationFocus.requestFocus();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:
                        requestAccessController.registrationTextController,
                    keyboardType: TextInputType.number,
                    focusNode: requestAccessController.registrationFocus,
                    decoration: const InputDecoration(labelText: 'Matrícula'),
                    validator: registrationValidator,
                    onEditingComplete: () {
                      requestAccessController.documentNumberFocus
                          .requestFocus();
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:
                        requestAccessController.documentNumberTextController,
                    keyboardType: TextInputType.number,
                    focusNode: requestAccessController.documentNumberFocus,
                    decoration: const InputDecoration(labelText: 'CPF'),
                    validator: documentValidator,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '###.###.###-##',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<RequestAccessController>(
                      builder: (context, controller, _) {
                    return Stack(
                      children: [
                        TextFormField(
                          controller: TextEditingController(
                              text: controller.dateFormatted),
                          decoration: const InputDecoration(
                            labelText: 'Data de nascimento',
                            suffixIcon: Icon(Icons.calendar_month_outlined),
                          ),
                          validator: dateValidator,
                        ),
                        Positioned.fill(
                          child: InkWell(
                            onTap: () async {
                              var now = DateTime.now();
                              final lastYear = now.year - 18;
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  lastDate:
                                      DateTime(lastYear, now.month, now.day),
                                  initialDate: controller.date);
                              if (date != null) {
                                controller.setDate(date);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Consumer<RequestAccessController>(
                          builder: (context, controller, _) {
                        return Checkbox(
                          value: controller.checkTerms,
                          onChanged: (value) =>
                              controller.changeCheckTerms(value),
                        );
                      }),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Declaro que lí e concordo com os ',
                            style: AppFonts.text.copyWith(
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                            children: [
                              TextSpan(
                                text: 'termos de uso',
                                style: AppFonts.title.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDefaultDialog(
                                      context,
                                      title:
                                          'Termo de uso da Plataforma e Política de Privacidade',
                                      contentText: termsOfUseToDialog,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Fechar'),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              requestAccessController
                                                  .changeCheckTerms(true);
                                              Navigator.pop(context);
                                            },
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Continuar'),
                                                SizedBox(width: 8),
                                                Icon(
                                                    Icons.arrow_forward_rounded)
                                              ],
                                            ))
                                      ],
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<RequestAccessController>(
                      builder: (context, controller, _) {
                    return ElevatedButton(
                      onPressed: (controller.checkTerms ?? false)
                          ? () {
                              requestAccessController.requestAccess(context);
                            }
                          : null,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Solicitar acesso'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded)
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
