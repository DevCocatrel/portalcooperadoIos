import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/date_format.dart';
import 'package:cocatrel/models/bonds_payable_model.dart';
import 'package:cocatrel/pages/bonds_payable/bonds_payable_controller.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BondsPayablePage extends StatelessWidget {
  BondsPayablePage({super.key});
  final bondsPayableController = BondsPayableController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: bondsPayableController,
      child: DefaultScaffoldWidget(
        drawer: const BasicMenuDrawer(),
        appBar: const ProfileAppBar(
          title: 'Títulos a pagar',
        ),
        body: Container(
          padding: const EdgeInsets.all(16).copyWith(top: 0),
          child: Consumer<BondsPayableController>(
              builder: (context, controller, _) {
            return Skeletonizer(
              enabled: controller.loading,
              child: RefreshIndicator(
                onRefresh: controller.fetchBondPayableList,
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    if (controller.bondsPayable.isLeft) ...{
                      const BasicCardError(
                          error: 'Erro ao carregar as informações'),
                    } else ...{
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: const Text('Títulos a pagar'),
                      ),
                      DefaultCardWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.article_rounded,
                                  color: AppColors.primaryDark,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Total de títulos a pagar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryDark,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Total',
                              style: AppFonts.text.copyWith(
                                color: AppColors.textColorLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Currency.format(controller
                                      .bondsPayable.right.totalBondsPayable ??
                                  .0),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.textColor),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Valor calculado com base no valor original do Titulo',
                                    style: AppFonts.text.copyWith(
                                      fontSize: 12,
                                      color: AppColors.textColorLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (controller
                              .bondsPayable.right.bondPayableList?.isNotEmpty ??
                          false) ...{
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text('Títulos em aberto'),
                        ),
                        ...controller.bondsPayable.right.bondPayableList!.map(
                          (item) => bondPayableWidget(item),
                        )
                      },
                    }
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget bondPayableWidget(BondPayableModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DefaultCardWidget(
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.request_quote_outlined,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.documentType ?? '',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RowWithDataWidget(title: 'Título', value: item.accountingId ?? ''),
            const DividerCardWidget(),
            RowWithDataWidget(title: 'Referência', value: item.reference ?? ''),
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'DT Lançamento',
              value: basicDateFormat(item.postingDate),
            ),
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'DT Vencimento',
              value: basicDateFormat(item.dueDate),
            ),
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'Dias atraso',
              value: (item.daysLate ?? 0).toString(),
            ),
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'Valor original do título',
              value: Currency.basicFormat(item.totalToPay ?? .0),
            ),
          ],
        ),
      ),
    );
  }
}
