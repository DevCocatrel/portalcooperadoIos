import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/title/title_with_icon_card_widget.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/brazilian_format_double.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:cocatrel/pages/deposit_slip/common/steps_widget.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/issue_invoice_index_steps_controller.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/resume/resume_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ResumeTab extends StatelessWidget {
  ResumeTab({super.key});

  final ResumeController resumeController = ResumeController();

  @override
  Widget build(BuildContext context) {
    final indexController = context.read<IssueInvoiceIndexController>();
    return ChangeNotifierProvider.value(
      value: resumeController,
      child: Consumer<ResumeController>(
        builder: (context, controller, _) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const StepsWidget(5, 'Resumo da emissão'),
                    DefaultCardWidget(
                      child: Column(
                        children: [
                          TitleWithIconCardWidget(
                            title: indexController.depositSlip.farm?.farmName ??
                                '',
                            icon: Icons.agriculture_outlined,
                          ),
                          RowWithDataWidget(
                              title: 'Inscrição',
                              value: indexController
                                      .depositSlip.farm?.registrationNumber ??
                                  ''),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DefaultCardWidget(
                      child: Column(
                        children: [
                          const TitleWithIconCardWidget(
                            title: 'Transporte',
                            icon: Icons.local_shipping_outlined,
                          ),
                          RowWithDataWidget(
                            title: 'Tipo de veículo',
                            value: indexController.depositSlip.vehicleType ==
                                    VehicleType.tractor
                                ? 'Trator'
                                : 'Licenciado',
                          ),
                          const DividerCardWidget(),
                          if (indexController.depositSlip.tractorBrand !=
                              null) ...{
                            const RowWithDataWidget(
                              title: 'Modelo',
                              value: 'Mercedes', //depositSlip.tractorBrand
                            ),
                            const DividerCardWidget(),
                          },
                          RowWithDataWidget(
                            title: 'Placa',
                            value: indexController.depositSlip.plate ?? '',
                          ),
                          if (indexController.depositSlip.uf != null) ...{
                            const DividerCardWidget(),
                            RowWithDataWidget(
                              title: 'UF da placa',
                              value: indexController.depositSlip.uf ?? '',
                            ),
                          },
                          if (indexController.depositSlip.carrier != null ||
                              indexController.depositSlip.carrierName !=
                                  null) ...{
                            const DividerCardWidget(),
                            RowWithDataWidget(
                              title: 'Transportadora',
                              value: indexController
                                      .depositSlip.carrier?.carrierName ??
                                  indexController.depositSlip.carrierName ??
                                  '',
                            ),
                          },
                          if (indexController.depositSlip.driverName !=
                              null) ...{
                            const DividerCardWidget(),
                            RowWithDataWidget(
                              title: 'Motorista',
                              value:
                                  indexController.depositSlip.driverName ?? '',
                            ),
                          },
                          if (indexController.depositSlip.documentNumber !=
                              null) ...{
                            const DividerCardWidget(),
                            RowWithDataWidget(
                              title: 'CPF/CNPJ Transportador',
                              value:
                                  indexController.depositSlip.documentNumber ??
                                      '',
                            ),
                          },
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DefaultCardWidget(
                      child: Column(
                        children: [
                          const TitleWithIconCardWidget(
                            title: 'Café',
                            icon: Icons.grain_outlined,
                          ),
                          RowWithDataWidget(
                            title: 'Tipo de café',
                            value: indexController.depositSlip.typeCoffee ==
                                    TypeCoffee.coffee
                                ? 'Café'
                                : 'Repasse/Escolha',
                          ),
                          const DividerCardWidget(),
                          RowWithDataWidget(
                            title: 'Processo de seca',
                            value: indexController.depositSlip.dryProcess ==
                                    DryProcess.normal
                                ? 'Normal'
                                : 'Cereja Descascada',
                          ),
                          const DividerCardWidget(),
                          RowWithDataWidget(
                            title: 'Personalizado?',
                            value: indexController.depositSlip.personalized
                                ? 'Sim'
                                : 'Não',
                          ),
                          const DividerCardWidget(),
                          RowWithDataWidget(
                            title: 'Quantidade em Sacas',
                            value: brazilianFormatDouble(
                                indexController.depositSlip.quantityBags),
                          ),
                          const DividerCardWidget(),
                          RowWithDataWidget(
                            title: 'Quantidade em Quilos',
                            value: brazilianFormatDouble(
                                indexController.depositSlip.quantityKgs),
                          ),
                          const DividerCardWidget(),
                          RowWithDataWidget(
                            title: 'Valor total',
                            value: Currency.format(
                                indexController.depositSlip.totalValue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DefaultCardWidget(
                      child: Column(
                        children: [
                          const TitleWithIconCardWidget(
                            title: 'Entrega',
                            icon: Icons.location_on_outlined,
                            svgPath: AppAssets.distance,
                          ),
                          RowWithDataWidget(
                            title: 'Local de entrega',
                            value: indexController
                                    .depositSlip.warehouse?.warehouseName ??
                                '',
                          ),
                          const DividerCardWidget(),
                          RowWithDataWidget(
                            title: 'Embalagem',
                            value: indexController
                                    .depositSlip.packaging?.packagingName ??
                                '',
                          ),
                          const DividerCardWidget(),
                          RowWithDataWidget(
                            title: 'Email NFE ',
                            value: indexController.depositSlip.emailNFE ?? '',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  indexController.tabController.animateTo(3);
                                },
                                child: Text(
                                  'Voltar',
                                  style: AppFonts.textButton,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final user =
                                      context.read<AuthProvider>().user;
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.loading,
                                    arguments: {
                                      'future': controller.issueInvoice(
                                        indexController.depositSlip,
                                        user?.name ?? '',
                                        user?.registration ?? '',
                                      ),
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Emitir NFE',
                                      style: AppFonts.textButton,
                                    ),
                                    const SizedBox(width: 8),
                                    controller.loading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            AppAssets.addNotes,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.buttonTextLight,
                                              BlendMode.srcIn,
                                            ),
                                          )
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
              if (controller.loading)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withValues(alpha: .2),
                    height: double.maxFinite,
                    width: double.maxFinite,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
