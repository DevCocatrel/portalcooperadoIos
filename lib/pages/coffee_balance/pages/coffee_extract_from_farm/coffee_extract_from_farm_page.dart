import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/dropdown/basic_dropdown.dart';
import 'package:cocatrel/common/widgets/dropdown/item/basic_dropdown_menu_item.dart';
import 'package:cocatrel/common/widgets/dropdown/menu/basic_dropdown_menu.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/models/farm_model.dart';
import 'package:cocatrel/models/lot_model.dart';
import 'package:cocatrel/pages/coffee_balance/pages/coffee_extract_from_farm/coffee_extract_from_farm_controller.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CoffeeExtractFromFarm extends StatelessWidget {
  CoffeeExtractFromFarm({super.key, required this.coffeeBalance}) {
    coffeeExtractFromFarmController =
        CoffeeExtractFromFarmController(coffeeBalance.farmRegistration ?? '');
  }

  final FarmModel coffeeBalance;

  late final CoffeeExtractFromFarmController coffeeExtractFromFarmController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coffeeExtractFromFarmController,
      child: DefaultScaffoldWidget(
        appBar: const ProfileAppBar(
          showBackButton: true,
        ),
        drawer: const BasicMenuDrawer(),
        body: Consumer<CoffeeExtractFromFarmController>(
            builder: (context, controller, _) {
          return RefreshIndicator(
            onRefresh: () async {
              controller
                  .fetchCoffeeExtract(coffeeBalance.farmRegistration ?? '');
            },
            child: Skeletonizer(
              enabled: controller.loading,
              child: Container(
                padding: const EdgeInsets.all(16).copyWith(bottom: 0, top: 0),
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Extrato de café',
                          style: AppFonts.title,
                        ),
                        BasicDropdown(
                          menu: BasicDropdownMenu(
                            items: [
                              BasicDropdownMenuItem(
                                isLast: false,
                                isFirst: true,
                                text: "Baixar extrato em PDF",
                                icon: const Icon(
                                  size: 24,
                                  Icons.picture_as_pdf_outlined,
                                  color: AppColors.buttonTextLight,
                                ),
                                onPressed: () {
                                  controller.downloadFile(coffeeBalance, 'pdf');
                                },
                              ),
                              BasicDropdownMenuItem(
                                isLast: true,
                                isFirst: false,
                                text: "Baixar extrato em CSV",
                                icon: SvgPicture.asset(
                                  AppAssets.csv,
                                  width: 20,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.textColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                onPressed: () {
                                  controller.downloadFile(
                                      coffeeBalance, 'excel');
                                },
                              ),
                            ],
                          ),
                          button: controller.loadingDownloadFile
                              ? Container(
                                  padding: const EdgeInsets.all(2),
                                  height: 20,
                                  width: 20,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.file_download_outlined,
                                  color: AppColors.primaryDark,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DefaultCardWidget(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.agriculture_outlined,
                                color: AppColors.primaryDark,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  coffeeBalance.farm ?? '',
                                  style: AppFonts.title.copyWith(
                                    fontSize: 14,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RowWithDataWidget(
                            title: 'Inscrição',
                            value: coffeeBalance.farmRegistration ?? '',
                          ),
                          const DividerCardWidget(),
                          RowWithDataWidget(
                            title: 'Sacas',
                            value: coffeeBalance.availableBalance.toString(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    if (controller.coffeeExtract.isRight) ...{
                      const Text('Lotes'),
                      const SizedBox(height: 16),
                      if (controller.coffeeExtract.right.lotList?.isEmpty ??
                          true) ...{
                        const BasicCardError(
                            error: 'Não há extrato para essa fazenda')
                      } else ...{
                        ...controller.coffeeExtract.right.lotList!.map(
                          (item) => itemCardWidget(context, item),
                        ),
                      }
                    } else
                      const BasicCardError(error: 'Erro ao carregar dados'),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  DefaultCardWidget itemCardWidget(BuildContext context, LotModel item) {
    return DefaultCardWidget(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.lotNumber ?? ''),
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        color: item.backgroundColor,
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.standardName ?? '',
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sacas entrada', style: AppFonts.text),
                      const SizedBox(height: 2),
                      Text((item.quantityReceived ?? .0).toString()),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sacas saldo', style: AppFonts.text),
                      const SizedBox(height: 2),
                      Text((item.balanceBags ?? .0).toString()),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.lotDetails, arguments: {
                          'lotDetails': item,
                          'coffeeBalance': coffeeBalance,
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Detalhes',
                            style: AppFonts.textButton,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(Icons.arrow_forward_rounded)
                        ],
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
