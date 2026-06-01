import 'package:cocatrel/common/widgets/cards/basic/basic_card.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/core/utils/hex_to_color.dart';
import 'package:cocatrel/models/dashboard_quote.dart';
import 'package:cocatrel/models/dashboard_quotes.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuotesSection extends StatelessWidget {
  final Either<Error, DashboardQuotes>? quotes;

  const QuotesSection({
    super.key,
    this.quotes,
  });

  @override
  Widget build(BuildContext context) {
    const title = "Principais cotações";

    if (quotes == null) {
      return _section(
        loading: true,
        title: title,
        subTitle: "00/00/00",
        quotes: List.generate(5, (index) {
          return DashboardQuote(
            classification: "COC 01",
            price: 0.00,
            percentage: "10%",
            backgroundColor: "#000",
            date: "00/00/00",
            textColor: "#000",
          );
        }),
      );
    }

    return quotes!.fold(
      (error) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicTitle(
                text: title,
              ),
              BasicCardError(
                error: "Erro ao carregar cotações",
              ),
            ],
          ),
        );
      },
      (quote) {
        final date = quote.date;
        final quotes = quote.quotes;

        if (quotes.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicTitle(
                  text: title,
                ),
                BasicCardError(
                  icon: Icon(
                    Icons.check_outlined,
                    color: AppColors.primaryColorDark,
                  ),
                  error: "Nenhuma cotação encontrada",
                ),
              ],
            ),
          );
        }

        return _section(
          title: title,
          subTitle: normalizeDate(date),
          quotes: quotes,
        );
      },
    );
  }

  Widget _section({
    required String title,
    required String subTitle,
    required List<DashboardQuote> quotes,
    bool loading = false,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: BasicTitle(
              text: title,
              subTitle: subTitle,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: quotes.asMap().entries.map((item) {
                var quote = item.value.classification;
                var backgroundColor = item.value.backgroundColor;
                var percentage = item.value.percentage;
                var priceFormatted = Currency.format(
                  item.value.price,
                );
                return Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: item.key == 0 ? 20 : 0,
                  ),
                  child: BasicCard(
                    icon: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: ColorTransform.hexToColor(
                          backgroundColor,
                          defaultColor: AppColors.primaryColorDark,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    items: [
                      CardSingleItem(
                        title: "Catação $percentage",
                        value: Text(
                          priceFormatted,
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    title: quote,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
