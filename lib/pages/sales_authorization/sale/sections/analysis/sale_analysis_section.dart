import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/hex_to_color.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/list_lots_by_farm_id_controller.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sale_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SaleAnalysisSection extends StatelessWidget {
  const SaleAnalysisSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lotes autorizados para a venda',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 26),
          _listBatches(context),
          const SizedBox(height: 26),
          Text(
            'Sumário',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 16),
          _summary(context),
        ],
      ),
    );
  }

  Widget _summary(BuildContext context) {
    var sale = Provider.of<SalePageController>(context, listen: false);

    return DefaultCardWidget(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _textItem(
              label: 'Fazenda',
              value: sale.farm.name,
              hasDivider: true,
            ),
            _textItem(
              label: 'Inscrição',
              value: sale.farm.inscription,
              hasDivider: true,
            ),
            _textItem(
              label: 'Total',
              value: Currency.format(sale.totalNetUnitPrice),
              hasDivider: true,
            ),
            _textItem(
              label: 'Total PreFixado',
              value: Currency.format(sale.totalFixedPrice),
              hasDivider: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                sale.nextStep();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Próximo',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.buttonTextLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.buttonTextLight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listBatches(BuildContext context) {
    var sale = Provider.of<SalePageController>(context, listen: false);

    return ListView.builder(
      itemCount: sale.batches.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var batch = sale.batches[index];
        var information = batch.information;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: DefaultCardWidget(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        information.batch,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: ColorTransform.hexToColor(
                                information.backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            information.standardClassification,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  _textItem(
                    label: 'Preço praticado',
                    value: convertModalityToString(batch.modality),
                    hasDivider: true,
                  ),
                  _textItem(
                    label: 'Sacas',
                    value: "${batch.bags} (${batch.weight} kg)",
                    hasDivider: true,
                  ),
                  _textItem(
                    label: "% Quebra",
                    value: batch.information.classificationPerBreak.toString(),
                    hasDivider: true,
                  ),
                  _textItem(
                    label: "Safra",
                    value: batch.information.harvestClassification,
                    hasDivider: true,
                  ),
                  _textItem(
                    label: "Pr. Unitário líquido",
                    value: batch.fixedPrice != null
                        ? Currency.format(batch.fixedPrice!)
                        : Currency.format(
                            batch.information.netUnitPrice,
                          ),
                    hasDivider: true,
                  ),
                  _textItem(
                    label: "Total",
                    value: batch.fixedPrice != null
                        ? Currency.format(batch.fixedPrice! * batch.bags)
                        : Currency.format(
                            batch.information.netUnitPrice * batch.bags,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
}
