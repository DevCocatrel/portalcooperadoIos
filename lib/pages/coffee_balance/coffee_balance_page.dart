import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/models/farm_model.dart';
import 'package:cocatrel/pages/coffee_balance/coffee_balance_controller.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CoffeeBalancePage extends StatelessWidget {
  CoffeeBalancePage({super.key});

  final coffeeBalanceController = CoffeeBalanceController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coffeeBalanceController,
      child: DefaultScaffoldWidget(
        drawer: const BasicMenuDrawer(),
        appBar: const ProfileAppBar(
          title: 'Saldo do café',
        ),
        body: Consumer<CoffeeBalanceController>(
            builder: (context, controller, _) {
          return RefreshIndicator(
            onRefresh: controller.fetchCoffeeBalance,
            displacement: 50,
            child: Container(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              child: Skeletonizer(
                enabled: controller.loading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: !controller.loading && controller.farms.isLeft
                      ? [
                          const BasicCardError(error: 'Erro ao carregar dados'),
                        ]
                      : [
                          if (controller.farms.right.isEmpty) ...{
                            const BasicCardError(
                                error: 'Não há saldo para mostrar'),
                          } else
                            Expanded(
                              child: ListView(
                                children: [
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                            'Relação de saldo de café por fazenda'),
                                      ),
                                      IconButton(
                                        onPressed: controller.downloadFile,
                                        icon: controller.loadingDownloadFile
                                            ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.file_download_outlined,
                                                color: AppColors.textColor,
                                              ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ...controller.farms.right.map<Widget>(
                                      (item) => farmCardWidget(context, item))
                                ],
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

  Widget farmCardWidget(BuildContext context, FarmModel coffeeBalance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DefaultCardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.agriculture,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 8),
                Text(
                  coffeeBalance.farm ?? '',
                  style: AppFonts.title.copyWith(
                    fontSize: 14,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RowWithDataWidget(
                title: 'Inscrição',
                value: coffeeBalance.farmRegistration ?? ''),
            const DividerCardWidget(),
            RowWithDataWidget(
                title: 'Sacas', value: coffeeBalance.balance.toString()),
            const DividerCardWidget(),
            RowWithDataWidget(
                title: 'Total líquido',
                value: coffeeBalance.authorizedBalance.toString()),
            const DividerCardWidget(),
            RowWithDataWidget(
                title: 'Bloqueado',
                value: coffeeBalance.blockedBalance.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      AppRoutes.coffeeExtractFromFarm,
                      arguments: {'farm': coffeeBalance});
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.exportNotes,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ver extrato',
                      style: AppFonts.textButton,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
