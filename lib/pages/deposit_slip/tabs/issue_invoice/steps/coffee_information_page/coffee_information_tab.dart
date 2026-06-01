import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/title/title_with_icon_card_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/input_formatters.dart';
import 'package:cocatrel/pages/deposit_slip/common/binary_selection_widget.dart';
import 'package:cocatrel/pages/deposit_slip/common/steps_widget.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/coffee_information_page/coffee_information_controller.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/issue_invoice_index_steps_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CoffeeInformationTab extends StatelessWidget {
  CoffeeInformationTab(DepositSlip depositSlip, {super.key}) {
    coffeeInformationController = CoffeeInformationController(depositSlip);
  }

  late final CoffeeInformationController coffeeInformationController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coffeeInformationController,
      child: Consumer<CoffeeInformationController>(
          builder: (context, controller, _) {
        return SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                const StepsWidget(3, 'Informações do Café'),
                DefaultCardWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleWithIconCardWidget(
                        title: 'Café',
                        icon: Icons.grain_outlined,
                      ),
                      BinarySelectionWidget(
                        title: 'Qual o tipo do café',
                        option1: 'Café',
                        option2: 'Repasse/Escolha',
                        optionSelected: controller.depositSlip.typeCoffee ==
                                TypeCoffee.coffee
                            ? 'Café'
                            : 'Repasse/Escolha',
                        onTap1: () {
                          controller.changeTypeCoffee(TypeCoffee.coffee);
                        },
                        onTap2: () {
                          controller.changeTypeCoffee(TypeCoffee.passOrChoose);
                        },
                      ),
                      const SizedBox(height: 16),
                      BinarySelectionWidget(
                        title: 'Qual o processo de seca?',
                        option1: 'Normal',
                        option2: 'Cereja Descascada',
                        optionSelected: controller.depositSlip.dryProcess ==
                                DryProcess.normal
                            ? 'Normal'
                            : 'Cereja Descascada',
                        onTap1: () {
                          controller.changeDryProcess(DryProcess.normal);
                        },
                        onTap2: () {
                          controller.changeDryProcess(DryProcess.peeledCherry);
                        },
                      ),
                      const SizedBox(height: 16),
                      BinarySelectionWidget(
                        title: 'É personalizado?',
                        option1: 'Sim',
                        option2: 'Não',
                        optionSelected:
                            controller.depositSlip.personalized ? 'Sim' : 'Não',
                        onTap1: () {
                          controller.changePersonalized(true);
                        },
                        onTap2: () {
                          controller.changePersonalized(false);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Informe a quantidade', style: AppFonts.text),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                                controller.onEditingComplete();
                              },
                              inputFormatters: [
                                QtddBagsInputFormatter(),
                              ],
                              controller: coffeeInformationController
                                  .quantityBagsTextController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Qtdd em sacas'),
                              onEditingComplete: () {
                                controller.onEditingComplete();
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (_) {
                                coffeeInformationController
                                    .onChangeQuantityBags();
                              },
                              validator: (value) {
                                return (value ?? '').isEmpty
                                    ? 'Insira um valor'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              enabled: false,
                              controller:
                                  coffeeInformationController.quantityKgs,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Qtdd em Kg',
                              ),
                              validator: (value) {
                                return (value ?? '').isEmpty
                                    ? 'Insira um valor'
                                    : null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      certificateWidget(controller),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Valor Total',
                            style: AppFonts.textButton.copyWith(
                              fontSize: 14,
                              color: AppColors.primaryColorDark,
                            ),
                          ),
                          Text(
                            Currency.format(controller.total),
                            style: AppFonts.textButton.copyWith(
                              fontSize: 14,
                              color: AppColors.primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              context
                                  .read<IssueInvoiceIndexController>()
                                  .tabController
                                  .animateTo(1);
                            },
                            child: Text(
                              'Voltar',
                              style: AppFonts.textButton,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final index =
                                  context.read<IssueInvoiceIndexController>();
                              if (controller.validate(index.depositSlip)) {
                                index.tabController.animateTo(3);
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Próximo',
                                  style: AppFonts.textButton,
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_outlined)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32)
              ],
            ),
          ),
        );
      }),
    );
  }

  Row certificateWidget(CoffeeInformationController controller) {
    final spitedCertificates =
        (controller.depositSlip.farmCertificates ?? '').split(' | ');
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.newReleases,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryDark,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Certificados',
          style: AppFonts.title.copyWith(
            color: AppColors.primaryDark,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
                style: AppFonts.text,
                children: spitedCertificates
                    .asMap()
                    .entries
                    .map(
                      (item) => TextSpan(
                        text: item.value,
                        children: [
                          if (item.key < (spitedCertificates.length - 1))
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                alignment: Alignment.center,
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                    color: AppColors.textColor,
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                            )
                        ],
                      ),
                    )
                    .toList()),
          ),
        ),
      ],
    );
  }
}
