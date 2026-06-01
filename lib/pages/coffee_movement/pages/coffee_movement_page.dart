import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/cards/title/title_with_icon_card_widget.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/dropdown/basic_dropdown.dart';
import 'package:cocatrel/common/widgets/dropdown/item/basic_dropdown_menu_item.dart';
import 'package:cocatrel/common/widgets/dropdown/menu/basic_dropdown_menu.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/utils/brazilian_format_double.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/models/coffee_movement_filter_model.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:cocatrel/pages/coffee_movement/pages/coffee_movement_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CoffeeMovementPage extends StatelessWidget {
  CoffeeMovementPage(this.coffeeMovementFilter, {super.key}) {
    coffeeMovementController = CoffeeMovementController(coffeeMovementFilter);
  }

  final CoffeeMovementFilterModel coffeeMovementFilter;

  late final CoffeeMovementController coffeeMovementController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coffeeMovementController,
      child: DefaultScaffoldWidget(
        appBar: const ProfileAppBar(
          showBackButton: true,
        ),
        drawer: const BasicMenuDrawer(),
        body: Consumer<CoffeeMovementController>(
            builder: (context, controller, _) {
          return Skeletonizer(
            enabled: controller.loading,
            child: RefreshIndicator(
              onRefresh: controller.fetchExtractMovement,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: controller.extractMovement.isLeft
                    ? [
                        const SizedBox(height: 32),
                        const BasicCardError(
                            error:
                                'Não há extrato para esse intervalo de datas')
                      ]
                    : [
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Resumo'),
                            controller.loadingDownload
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : BasicDropdown(
                                    button: const Icon(
                                      Icons.file_download_outlined,
                                      color: AppColors.primaryDark,
                                    ),
                                    menu: BasicDropdownMenu(
                                      items: [
                                        BasicDropdownMenuItem(
                                          isFirst: true,
                                          isLast: false,
                                          icon: const Icon(
                                              Icons.picture_as_pdf_outlined),
                                          text: 'Baixar movimentação em PDF',
                                          onPressed: () {
                                            controller.downloadFile('print');
                                          },
                                        ),
                                        BasicDropdownMenuItem(
                                          isLast: true,
                                          isFirst: false,
                                          icon: const Icon(Icons.backup_table),
                                          text: 'Baixar movimentação em XLSX',
                                          onPressed: () {
                                            controller.downloadFile('excel');
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                        const SizedBox(height: 16),
                        filterDetailsWidget(controller),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Movimentações'),
                        ),
                        if (controller
                                .extractMovement.right.movementsList?.isEmpty ??
                            true)
                          const BasicCardError(
                              error: 'Não há extratos para listar'),
                        ...(controller.extractMovement.right.movementsList ??
                                [])
                            .map(
                          (item) => DefaultCardWidget(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.lot ?? '',
                                      style: const TextStyle(
                                          color: AppColors.primaryDark),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: item.typeES == 'S'
                                            ? AppColors.infoLight
                                            : AppColors.warningLight,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            item.typeES == 'S'
                                                ? Icons.arrow_upward_rounded
                                                : Icons.arrow_downward_rounded,
                                            size: 18,
                                            color: item.typeES == 'S'
                                                ? AppColors.infoDark
                                                : AppColors.warningDark,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            item.typeES == 'S'
                                                ? 'Retirada'
                                                : 'Armazenagem',
                                            style: TextStyle(
                                              color: item.typeES == 'S'
                                                  ? AppColors.infoDark
                                                  : AppColors.warningDark,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                RowWithDataWidget(
                                  title: 'Fazenda',
                                  value: item.farmName ?? '',
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Data',
                                  value: normalizeDate(item.movementDate ?? ''),
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'NFE',
                                  value: item.invoice ?? '',
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Tipo ENT/SAID',
                                  value: item.typeES ?? '',
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Histórico',
                                  value: item.history ?? '',
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Qtd. Sacas',
                                  value: brazilianFormatDouble(
                                      item.quantityBags ?? .0),
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Saldo Sacas',
                                  value: brazilianFormatDouble(
                                      item.balanceBags ?? .0),
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Safra',
                                  value: item.crop ?? '',
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Padrão',
                                  value: item.standard ?? '',
                                  valueWidget: Text(
                                    item.standard ?? '',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textColorLight,
                                    ),
                                  ),
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Peneira',
                                  value: item.sieve ?? '',
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Seca (%)',
                                  value: brazilianFormatDouble(
                                      item.percentageDry ?? .0),
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Certificados',
                                  value: item.certificate ?? '',
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Personalizado',
                                  value: item.customized ?? '',
                                ),
                                const DividerCardWidget(),
                                RowWithDataWidget(
                                  title: 'Pontuação',
                                  value:
                                      brazilianFormatDouble(item.score ?? .0),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
              ),
            ),
          );
        }),
      ),
    );
  }

  DefaultCardWidget filterDetailsWidget(CoffeeMovementController controller) {
    return DefaultCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithIconCardWidget(
            title: coffeeMovementFilter.farm.title ?? '',
            icon: Icons.agriculture_outlined,
          ),
          RowWithDataWidget(
            title: 'Tipo de movimento',
            value: coffeeMovementFilter.movementType.title ?? '',
          ),
          const DividerCardWidget(),
          RowWithDataWidget(
            title: 'Periodo',
            value:
                '${coffeeMovementFilter.startDate} - ${coffeeMovementFilter.endDate}',
          ),
          if (coffeeMovementFilter.movementType.value == 'T') ...{
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'Saldo anterior',
              value: brazilianFormatDouble(
                  controller.extractMovement.right.initialBalanceBags ?? .0),
            ),
          },
          if ((controller.extractMovement.right.periodEntries ?? .0) > .0) ...{
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'Entradas no período (+)',
              value: brazilianFormatDouble(
                  controller.extractMovement.right.periodEntries ?? .0),
            ),
          },
          if ((controller.extractMovement.right.periodExits ?? .0) > 0) ...{
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'Retiradas no período (-)',
              value: brazilianFormatDouble(
                  controller.extractMovement.right.periodExits ?? .0),
            ),
          },
          if ((controller.extractMovement.right.finalBalance ?? .0) > .0) ...{
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'Saldo final',
              value: brazilianFormatDouble(
                  controller.extractMovement.right.finalBalance ?? .0),
            ),
          }
        ],
      ),
    );
  }
}
