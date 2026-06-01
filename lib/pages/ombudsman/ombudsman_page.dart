import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/validators.dart';
import 'package:cocatrel/models/option_model.dart';
import 'package:cocatrel/pages/ombudsman/ombudsman_controller.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OmbudsmanPage extends StatelessWidget {
  OmbudsmanPage({super.key});

  final OmbudsmanController controller = OmbudsmanController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: DefaultScaffoldWidget(
        drawer: const BasicMenuDrawer(),
        appBar: const ProfileAppBar(title: 'Ouvidoria'),
        body: Consumer<OmbudsmanController>(builder: (context, controller, _) {
          return Skeletonizer(
            enabled: controller.loadingOmbudsman,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text('Enviar mensagem'),
                    const SizedBox(height: 16),
                    DefaultCardWidget(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.mail_outline_rounded,
                                  color: AppColors.primaryDark,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Ouvidoria Cotatrel',
                                  style: TextStyle(
                                    color: AppColors.primaryDark,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Gostaria de falar com a ouvidoria sobre algum assunto? Envie sua mensagem.',
                              style: AppFonts.text,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<OptionModel>(
                              initialValue: controller.currentSubject,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                              ),
                              hint: const Text('Assunto'),
                              validator: (value) {
                                if (controller.currentSubject == null) {
                                  return 'Selecione um assunto';
                                }
                                return null;
                              },
                              items:
                                  (controller.ombudsmanOptions?.subjects ?? [])
                                      .map(
                                        (option) =>
                                            DropdownMenuItem<OptionModel>(
                                          value: option,
                                          child: Text(
                                            option.title ?? '',
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: controller.setCurrentSubject,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<OptionModel>(
                              initialValue: controller.currentDepartment,
                              hint: const Text('Departamento'),
                              validator: (value) {
                                if (controller.currentDepartment == null) {
                                  return 'Selecione um departamento';
                                }
                                return null;
                              },
                              items: (controller
                                          .ombudsmanOptions?.departments ??
                                      [])
                                  .map(
                                    (option) => DropdownMenuItem<OptionModel>(
                                      value: option,
                                      child: Text(
                                        option.title ?? '',
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: controller.setCurrentDepartment,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: controller.nameTextController,
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                              ),
                              onEditingComplete:
                                  controller.phoneFocus.requestFocus,
                              validator: nameValidator,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: controller.phoneTextController,
                              focusNode: controller.phoneFocus,
                              decoration: const InputDecoration(
                                labelText: 'Telefone',
                              ),
                              inputFormatters: [
                                MaskTextInputFormatter(
                                  mask: '(##) #####-####',
                                  filter: {"#": RegExp(r'[0-9]')},
                                  type: MaskAutoCompletionType.lazy,
                                )
                              ],
                              onEditingComplete:
                                  controller.messageFocus.requestFocus,
                              validator: (value) {
                                if (value == null) return null;
                                if (!(controller.confirmReturns ?? false)) {
                                  if (value.isEmpty) return null;
                                }
                                return phoneValidator(value);
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              minLines: 5,
                              maxLines: 5,
                              controller: controller.messageTextController,
                              focusNode: controller.messageFocus,
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: const InputDecoration(
                                labelText: 'Mensagem',
                              ),
                              validator: (value) {
                                if (value == null) return null;
                                if (value.isEmpty) {
                                  return 'Insira uma mensagem';
                                }
                                if (value.length < 5) {
                                  return 'Insira uma mensagem válida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: controller.confirmReturns ?? false,
                                  onChanged: controller.setConfirmReturns,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Desejo receber um retorno sobre o assunto.',
                                    style: AppFonts.text,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                                onPressed: () {
                                  controller.sendMessage(
                                    context
                                            .read<AuthProvider>()
                                            .user
                                            ?.registration ??
                                        '',
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Enviar mensagem',
                                      style: AppFonts.text.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 8),
                                    controller.loadingSendMessage
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_rounded)
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
