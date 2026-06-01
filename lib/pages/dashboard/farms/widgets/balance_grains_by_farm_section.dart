import 'package:cocatrel/common/widgets/cards/basic/basic_card.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BalanceGrainsByFarmSection extends StatelessWidget {
  final Either<Error, DashboardData>? grainsByFarm;

  const BalanceGrainsByFarmSection({
    super.key,
    this.grainsByFarm,
  });

  @override
  Widget build(BuildContext context) {
    const title = "Saldo Soja/Milho";

    if (grainsByFarm == null) {
      return _section(
        loading: true,
        title: title,
        soyBalanceBags: 0,
        soyBalanceKg: 0,
        cornBalanceBags: 0,
        cornBalanceKg: 0,
      );
    }

    return grainsByFarm!.fold(
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
                error: "Erro ao carregar dados",
              ),
              SizedBox(height: 8),
              BasicCardError(
                error: "Erro ao carregar dados",
              ),
            ],
          ),
        );
      },
      (balance) {
        return _section(
          loading: false,
          title: title,
          soyBalanceBags: balance.soyBalanceBags,
          soyBalanceKg: balance.soyBalanceKg,
          cornBalanceBags: balance.cornBalanceBags,
          cornBalanceKg: balance.cornBalanceKg,
        );
      },
    );
  }

  Widget _section({
    required String title,
    bool loading = false,
    required double soyBalanceBags,
    required double soyBalanceKg,
    required double cornBalanceBags,
    required double cornBalanceKg,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            BasicTitle(text: title),
            BasicCard(
              title: "Soja",
              icon: const Icon(
                Icons.agriculture_rounded,
                color: AppColors.primaryColorDark,
                size: 24,
              ),
              items: [
                CardSingleItem(
                  title: 'Saldo em Kg',
                  value: Text(
                    soyBalanceKg.toString(),
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CardSingleItem(
                  title: 'Saldo em sacas',
                  value: Text(
                    soyBalanceBags.toString(),
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            BasicCard(
              title: "Milho",
              icon: const Icon(
                Icons.agriculture_rounded,
                color: AppColors.primaryColorDark,
                size: 24,
              ),
              items: [
                CardSingleItem(
                  title: 'Saldo em Kg',
                  value: Text(
                    cornBalanceKg.toString(),
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CardSingleItem(
                  title: 'Saldo em sacas',
                  value: Text(
                    cornBalanceBags.toString(),
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
