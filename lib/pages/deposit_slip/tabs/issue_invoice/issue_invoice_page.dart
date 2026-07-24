import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/cards/title/title_with_icon_card_widget.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/is_cnpj.dart';
import 'package:cocatrel/models/deposit_farm_list_model.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/issue_invoice_controller.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/index_deposit_slip_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cocatrel/core/app/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class IssueInvoiceTab extends StatelessWidget {
  IssueInvoiceTab(this.onIssueInvoice, {super.key});

  final issueInvoiceController = IssueInvoiceController();

  final void Function(int) onIssueInvoice;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: issueInvoiceController,
      child: Consumer<IssueInvoiceController>(
        builder: (context, controller, _) {
          return Skeletonizer(
            enabled: controller.loadingFarms,
            child: RefreshIndicator(
              onRefresh: controller.fetchFarms,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 32),
                  const Text('Emitir NFE de Entrada de Café'),
                  const SizedBox(height: 16),
                  if (controller.depositFarms.isLeft) ...{
                    const BasicCardError(error: 'Erro ao carregar fazendas')
                  } else if (controller.depositFarms.right.farmList?.isEmpty ??
                      true) ...{
                    const BasicCardError(error: 'Não há fazendas para listar')
                  } else ...{
                    ...(controller.depositFarms.right.farmList ?? [])
                        .asMap()
                        .entries
                        .map(
                          (entity) => farmItemWidget(context, entity),
                        ),
                    const SizedBox(height: 16)
                  }
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DefaultCardWidget farmItemWidget(
      BuildContext context, MapEntry<int, Farm> entity) {
    return DefaultCardWidget(
      margin: EdgeInsets.only(top: entity.key != 0 ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithIconCardWidget(
            title: entity.value.farmName ?? '',
            icon: Icons.agriculture_outlined,
            titleFontSize: 14,
          ),
          const SizedBox(height: 16),
          RowWithDataWidget(
            title: 'Inscrição',
            value: entity.value.registrationNumber ?? '',
          ),
          const DividerCardWidget(),
          RowWithDataWidget(
            title: 'Cidade',
            value: entity.value.farmCity ?? '',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final user = context.read<AuthProvider>().user;
              final documentNumber = user?.cpfCnpj;

              if (isCNPJ(documentNumber ?? '')) {
                showDefaultDialog(
                  context,
                  title: '⚠️ Emissão não permitida',
                  contentText:
                      '''Seu cadastro está identificado como Pessoa Jurídica (PJ).
A emissão de Nota Fiscal de Entrada de Café está disponível apenas para Pessoas Físicas''',

                  // Adicionando os botões de ação (exemplo comum em widgets customizados)
                  actions: [
                    // Botão Voltar
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Voltar'),
                    ),

                    // Botão Orientações
                    ElevatedButton(
                      onPressed: () async {
                        final Uri url =
                            Uri.parse(AppConfig.invoiceOrientatioLink);
                        try {
                          // Tenta abrir diretamente no modo externo
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          print('Erro ao tentar abrir o link: $e');
                        }
                      },
                      child: const Text('Orientações'),
                    ),
                  ],
                );
                return;
              }

              showDefaultDialog(
                context,
                title: 'Termo de responsabilidade',
                contentText:
                    '''Na qualidade de associado(a) da COCATREL me comprometo a preencher, devidamente, os dados necessários para a regular emissão da Nota Fiscal Eletrônica voltada para respaldar o transporte e respectivo depósito do café por mim produzido, tendo inteira ciência de que a inclusão de dados incorretos poderá ensejar autuações, as quais, desde já, saliento que serei responsável, isentando a cooperativa de eventual corresponsabilidade.

Esclareço, ainda, que estou consciente que o preenchimento incorreto e/ou incompleto dos dados relativos à Nota Fiscal Eletrônica poderá ocasionar a recusa da seguradora em pagar a respectiva indenização no caso de sinistro; tendo pleno conhecimento, quanto a isso, da importância em se atentar para a obrigatoriedade de existência de RNTRC (Registro Nacional de Transportadores Rodoviários de Carga) junto à ANTT (Agência Nacional de Transportes Terrestres) na hipótese do transporte do café não ser realizado em veículo próprio/particular.

Como prova de que estou inteiramente ciente das obrigações por mim assumidas (e das consequências delas advindas) oriundas do presente termo particular, concedo, de maneira livre e consciente, meu pleno e irrevogável aceite ao mesmo, ao clicar na “opção” “aceitar” e passar a preencher, por minha conta e risco, os campos da respectiva Nota Fiscal Eletrônica a ser por mim emitida.''',
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Fechar',
                      style: TextStyle(
                        color: AppColors.buttonTextLight,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      issueInvoiceController.setCurrentFarm(
                          value: entity.value,
                          cooperatorName: user?.name,
                          registration: user?.registration);
                      Navigator.of(context).pop();
                      final toTab = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => IssueInvoiceStepsPage(
                              issueInvoiceController.depositSlip),
                        ),
                      );

                      if (toTab != null) {
                        onIssueInvoice(toTab);
                      }

                      issueInvoiceController.setCurrentFarm(
                        value: null,
                        registration: null,
                        cooperatorName: null,
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Emitir guia',
                          style: TextStyle(
                            color: AppColors.buttonTextLight,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_outlined,
                          color: AppColors.buttonTextLight,
                        )
                      ],
                    ),
                  )
                ],
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppAssets.exportNotes,
                  colorFilter: const ColorFilter.mode(
                    Color.fromARGB(255, 25, 23, 17),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Emitir guia',
                  style: AppFonts.textButton,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
