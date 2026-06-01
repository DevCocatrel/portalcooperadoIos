import 'package:cocatrel/common/widgets/cards/basic/basic_card.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BalanceSection extends StatelessWidget {
  final Either<Error, DashboardData>? balance;

  const BalanceSection({super.key, this.balance});

  @override
  Widget build(BuildContext context) {
    const title = "Saldo";

    if (balance == null) {
      return _section(
        loading: true,
        title: title,
        balanceCafeBagsDate: "00/00/0000",
        balanceCoffeeBags: 0.0,
        balanceCafeBlocked: 0.0,
        totalTitlesOpen: "0,00",
        balanceCashBackDate: "00/00/0000",
        balanceCashBackLastYear: "0,00",
        balanceCashBackThisYear: "0,00",
        balanceAccountCapital: "0,00",
        balanceAccountCapitalDate: "00/00/0000",
        thisYear: "0000",
        lastYear: "0000",
      );
    }

    return balance!.fold(
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
                error: "Erro ao carregar as informações",
              ),
              SizedBox(height: 6),
              BasicCardError(
                error: "Erro ao carregar as informações",
              ),
              SizedBox(height: 6),
              BasicCardError(
                error: "Erro ao carregar as informações",
              ),
              SizedBox(height: 6),
              BasicCardError(
                error: "Erro ao carregar as informações",
              ),
            ],
          ),
        );
      },
      (balance) {
        final thisYear = DateTime.now().year.toString();
        final lastYear = (DateTime.now().year - 1).toString();

        final balanceCoffeeBags = balance.balanceCoffeeBags;
        final balanceCafeBlocked = balance.balanceCafeBlocked;
        final balanceCafeBagsDate = normalizeDate(balance.balanceCafeBagsDate);

        final totalTitlesOpen = Currency.format(balance.totalTitlesOpen);

        final balanceCashBackDate = normalizeDate(balance.balanceCashBackDate);
        final balanceCashBackLastYear =
            Currency.format(balance.balanceCashBackA);

        final balanceCashBackThisYear =
            Currency.format(balance.balanceCashBackB);

        final balanceAccountCapital =
            Currency.format(balance.balanceAccountCapital);
        final balanceAccountCapitalDate =
            normalizeDate(balance.balanceAccountCapitalDate);

        return _section(
          title: title,
          balanceCafeBagsDate: balanceCafeBagsDate,
          balanceCoffeeBags: balanceCoffeeBags,
          balanceCafeBlocked: balanceCafeBlocked,
          totalTitlesOpen: totalTitlesOpen,
          balanceCashBackDate: balanceCashBackDate,
          balanceCashBackLastYear: balanceCashBackLastYear,
          balanceCashBackThisYear: balanceCashBackThisYear,
          balanceAccountCapital: balanceAccountCapital,
          balanceAccountCapitalDate: balanceAccountCapitalDate,
          thisYear: thisYear,
          lastYear: lastYear,
        );
      },
    );
  }

  Widget _section({
    bool loading = false,
    required String title,
    required String balanceCafeBagsDate,
    required double balanceCoffeeBags,
    required double balanceCafeBlocked,
    required String totalTitlesOpen,
    required String balanceCashBackDate,
    required String balanceCashBackLastYear,
    required String balanceCashBackThisYear,
    required String balanceAccountCapital,
    required String balanceAccountCapitalDate,
    required String thisYear,
    required String lastYear,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            BasicTitle(text: title),
            BasicCard(
              fullWidth: true,
              title: "Saldo de café",
              subTitle: balanceCafeBagsDate,
              icon: const Icon(
                Icons.attach_money_outlined,
                color: AppColors.primaryColorDark,
              ),
              onPressed: () {
                Navigator.of(App.navigatorKey.currentContext!)
                    .pushNamed(AppRoutes.coffeeBalance);
              },
              items: [
                CardSingleItem(
                  title: "Sacas",
                  value: Text(
                    balanceCoffeeBags.toString(),
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CardSingleItem(
                  title: "Bloqueio",
                  value: Text(
                    balanceCafeBlocked.toString(),
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            BasicCard(
              fullWidth: true,
              title: "Títulos a pagar",
              icon: const Icon(
                Icons.payments_outlined,
                color: AppColors.primaryColorDark,
              ),
              onPressed: () {
                Navigator.of(App.navigatorKey.currentContext!)
                    .pushNamed(AppRoutes.bondsPayable);
              },
              items: [
                CardSingleItem(
                  title: "Títulos",
                  value: Text(
                    totalTitlesOpen,
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            BasicCard(
              fullWidth: true,
              title: "Saldo de cashback",
              subTitle: balanceCashBackDate,
              icon: SvgPicture.asset(
                AppAssets.attachMoneyArrowDown,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryColorDark,
                  BlendMode.srcIn,
                ),
              ),
              items: [
                CardSingleItem(
                  title: lastYear,
                  value: Text(
                    balanceCashBackLastYear,
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CardSingleItem(
                  title: thisYear,
                  value: Text(
                    balanceCashBackThisYear,
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            BasicCard(
              fullWidth: true,
              title: "Saldo conta capital",
              subTitle: balanceAccountCapitalDate,
              icon: const Icon(
                Icons.account_balance_outlined,
                color: AppColors.primaryColorDark,
              ),
              items: [
                CardSingleItem(
                  value: Text(
                    balanceAccountCapital,
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
