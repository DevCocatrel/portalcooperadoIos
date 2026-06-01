import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/models/market_price_model.dart';
import 'package:cocatrel/pages/commodity_price/commodity_price_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommodityPricePage extends StatelessWidget {
  CommodityPricePage({super.key});

  final commodityPriceController = CommodityPriceController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: commodityPriceController,
      child: DefaultScaffoldWidget(
        backgroundColor: AppColors.stockExchangeBackgroundColor,
        drawer: const BasicMenuDrawer(),
        appBar: const ProfileAppBar(
          title: 'Bolsa de Commodities',
        ),
        body: Consumer<CommodityPriceController>(
          builder: (_, controller, __) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.stockExchangeBackgroundColor,
            ),
            child: Skeletonizer(
              enabled: controller.loading,
              child: RefreshIndicator(
                onRefresh: controller.fetchCommodityPrices,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      if (controller.data.isRight)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            controller.data.right.dataHoraCotacao ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ...controller.group
                          .map((item) => sessionWidget(context, item)),
                      const SizedBox(height: 16)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column sessionWidget(BuildContext context, Group group) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryColor,
          ),
          child: Text(
            group.title,
            style: AppFonts.title.copyWith(
              color: AppColors.stockExchangeBackgroundColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        group.marketPrices.length == 1
            ? commodityDollarWidget(
                context,
                group.marketPrices.first,
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...group.marketPrices.asMap().entries.map(
                          (item) => commodityItemWidget(
                            context,
                            item.value,
                            leftMargin: item.key == 0 ? 16 : 0,
                          ),
                        ),
                  ],
                ),
              ),
        const SizedBox(height: 16),
      ],
    );
  }

  Container commodityItemWidget(
      BuildContext context, MarketPriceModel marketPrice,
      {double leftMargin = 0}) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 1.5,
      margin: EdgeInsets.only(left: leftMargin, right: 16),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF040404),
        border: Border.all(
          width: 1,
          color: AppColors.stockExchangeBorderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            marketPrice.contrato ?? '',
            style: AppFonts.title.copyWith(
              color: AppColors.stockExchangeTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${marketPrice.descContrato ?? ''} ${marketPrice.cotacao}',
            style: AppFonts.text.copyWith(
              color: AppColors.stockExchangeTextColor,
            ),
          ),
          const SizedBox(height: 16),
          itemWidget('Último', marketPrice.ultimo ?? ''),
          itemWidget('Dif.', marketPrice.dif ?? '', colorizeText: true),
          itemWidget('%', marketPrice.percentual ?? '', colorizeText: true),
          itemWidget('Fech.', marketPrice.fechamento ?? ''),
          itemWidget('Fech. Ant', marketPrice.fechamentoAnterior ?? ''),
          itemWidget('Max.', marketPrice.maximo ?? ''),
          itemWidget('Min.', marketPrice.minimo ?? ''),
          itemWidget('Compra', marketPrice.compra ?? ''),
          itemWidget('Venda', marketPrice.venda ?? ''),
          itemWidget('Abert.', marketPrice.abertura ?? '', isLast: true),
        ],
      ),
    );
  }

  Widget itemWidget(
    String title,
    String value, {
    bool colorizeText = false,
    String? position,
    bool isLast = false,
  }) {
    Color textColor = AppColors.stockExchangeTextColor;

    bool isNegative = value.isNotEmpty && value[0] == '-';

    if (colorizeText) {
      if (isNegative) {
        textColor = AppColors.stockExchangeDangerColor;
      } else {
        textColor = AppColors.stockExchangeGreenColor;
      }
    }

    TextStyle style = AppFonts.text.copyWith(color: textColor);

    if (colorizeText || position != null) {
      style = AppFonts.title.copyWith(color: textColor, fontSize: 14);
    }

    final richText = RichText(
      text: TextSpan(
          text: value,
          style: style,
          children: colorizeText
              ? [
                  const TextSpan(text: ''),
                  WidgetSpan(
                      child: Container(
                    margin: const EdgeInsets.only(left: 6),
                    child: Transform.translate(
                      offset: const Offset(0, -6),
                      child: SvgPicture.asset(isNegative
                          ? AppAssets.arrowDropDown
                          : AppAssets.arrowDropUp),
                    ),
                  ))
                ]
              : []),
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppFonts.text.copyWith(
                color: AppColors.stockExchangeTextColor,
              ),
            ),
            position == null
                ? richText
                : Container(
                    height: 25,
                    width: 66,
                    decoration: BoxDecoration(
                      color: position.toUpperCase() == 'A'
                          ? const Color(0xFFCC0000)
                          : AppColors.stockExchangeGreenColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    alignment: Alignment.center,
                    child: richText,
                  ),
          ],
        ),
        const SizedBox(height: 8),
        if (!isLast) ...{
          const Divider(
            color: AppColors.stockExchangeBorderColor,
            height: 1,
          ),
          const SizedBox(height: 8),
        }
      ],
    );
  }

  Container commodityDollarWidget(
    BuildContext context,
    MarketPriceModel marketPrice,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF040404),
        border: Border.all(
          width: 1,
          color: AppColors.stockExchangeBorderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            marketPrice.contrato ?? '',
            style: AppFonts.title.copyWith(
              color: AppColors.stockExchangeTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${marketPrice.descContrato ?? ''} ${marketPrice.cotacao}',
            style: AppFonts.text.copyWith(
              color: AppColors.stockExchangeTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: itemWidget(
                'Último',
                marketPrice.ultimo ?? '',
                position: marketPrice.posicao,
              )),
              const SizedBox(width: 16),
              Expanded(child: itemWidget('Max.', marketPrice.maximo ?? '')),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: itemWidget('Dif.', marketPrice.dif ?? '',
                      colorizeText: true)),
              const SizedBox(width: 16),
              Expanded(child: itemWidget('Min.', marketPrice.minimo ?? '')),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: itemWidget('%', marketPrice.percentual ?? '',
                      colorizeText: true)),
              const SizedBox(width: 16),
              Expanded(child: itemWidget('Compra', marketPrice.compra ?? '')),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: itemWidget('Fech.', marketPrice.fechamento ?? '')),
              const SizedBox(width: 16),
              Expanded(child: itemWidget('Venda', marketPrice.venda ?? '')),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: itemWidget(
                'Fech. Ant',
                marketPrice.fechamentoAnterior ?? '',
                isLast: true,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: itemWidget(
                'Abert.',
                marketPrice.abertura ?? '',
                isLast: true,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
