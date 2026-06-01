import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/hex_to_color.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/list_lots_by_farm_id_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          _buildHeader(context),
          _buildContent(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 16, left: 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
      ),
      child: Row(
        children: [
          Text(
            "Finalizar autorização",
            style: GoogleFonts.montserrat(
              color: AppColors.buttonTextLight,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: AppColors.buttonTextLight,
              size: 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _buildContent(BuildContext context) {
    final ListLotsByFarmIdController controller =
        Provider.of<ListLotsByFarmIdController>(context, listen: true);

    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemCount: controller.batches.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = controller.batches[index];
                  final isLast = index == controller.batches.length - 1;

                  return Container(
                    padding: EdgeInsets.only(bottom: !isLast ? 8 : 0),
                    margin: EdgeInsets.only(bottom: isLast ? 8 : 0),
                    child: DefaultCardWidget(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                item.information.batch,
                                style: GoogleFonts.montserrat(
                                  color: AppColors.primaryColorDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  controller.removeByBatch(
                                    item.information.batch,
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Icon(
                                    Icons.delete_outlined,
                                    color: AppColors.danger,
                                    size: 24,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          _textItem(
                            label: "Fazenda",
                            value: controller.farm.name,
                            hasDivider: true,
                          ),
                          _textItemCoc(item),
                          _textItem(
                            label: "Preço praticado",
                            value: convertModalityToString(item.modality),
                            hasDivider: true,
                          ),
                          _textItem(
                            label: "Sacas",
                            value: "${item.bags.toString()} (${item.weight}kg)",
                            hasDivider: true,
                          ),
                          _textItem(
                            label: "% Quebra",
                            value: item.information.classificationPerBreak
                                .toString(),
                            hasDivider: true,
                          ),
                          _textItem(
                            label: "Safra",
                            value: item.information.harvestClassification,
                            hasDivider: true,
                          ),
                          _textItem(
                            label: "Pr. Unitário líquido",
                            value: item.fixedPrice != null
                                ? Currency.format(item.fixedPrice!)
                                : Currency.format(
                                    item.information.netUnitPrice,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  _buildFooter(BuildContext context) {
    return Consumer<ListLotsByFarmIdController>(
        builder: (context, controller, _) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border(
            top: BorderSide(
              color: AppColors.borderColor,
            ),
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Text(
                  "Voltar",
                  style: GoogleFonts.montserrat(
                    color: AppColors.buttonTextLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: controller.batches.isEmpty
                  ? null
                  : () {
                      Navigator.of(context).pop();

                      Navigator.of(context).pushNamed(
                        AppRoutes.authorizationSale,
                        arguments: {
                          'batches': controller.batches,
                          'farm': controller.farm,
                          'openTitles': controller.openTitles,
                        },
                      );
                    },
              child: Row(
                children: [
                  const Icon(
                    Icons.price_check_rounded,
                    size: 24,
                    color: AppColors.buttonTextLight,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Autorizar",
                    style: GoogleFonts.montserrat(
                      color: AppColors.buttonTextLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _textItem({
    required String label,
    required String value,
    bool hasDivider = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: AppColors.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.montserrat(
                  color: AppColors.textColorLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        if (hasDivider)
          const Divider(
            color: AppColors.borderColor,
            height: 16,
          ),
      ],
    );
  }

  Widget _textItemCoc(AuthorizationItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Padrão",
              style: GoogleFonts.montserrat(
                color: AppColors.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: ColorTransform.hexToColor(
                        item.information.backgroundColor),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.information.standardClassification,
                  style: GoogleFonts.montserrat(
                    color: AppColors.textColorLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(
          color: AppColors.borderColor,
          height: 16,
        ),
      ],
    );
  }
}
