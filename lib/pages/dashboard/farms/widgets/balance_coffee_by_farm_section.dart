import 'package:cocatrel/common/widgets/cards/basic/basic_card.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/dashboard_balance_by_farm.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BalanceCoffeeByFarmSection extends StatelessWidget {
  final Either<Error, DashboardData>? coffeeByFarm;

  const BalanceCoffeeByFarmSection({
    super.key,
    this.coffeeByFarm,
  });

  @override
  Widget build(BuildContext context) {
    const title = "Saldo de Café por fazenda";

    if (coffeeByFarm == null) {
      return _section(
        loading: true,
        title: title,
        items: List.generate(
          2,
          (index) => DashboardBalanceByFarm(
            name: 'Lorem Ipsum',
            inscription: '000000000.00-00',
            balance: 999.99,
            blocked: 0.0,
          ),
        ),
      );
    }

    return coffeeByFarm!.fold(
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
              )
            ],
          ),
        );
      },
      (balance) {
        final farms = balance.balanceByFarm;

        if (farms.isEmpty) {
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
                  error: "Você não possui saldo em suas fazendas",
                ),
              ],
            ),
          );
        }

        return _section(
          loading: false,
          title: title,
          items: farms,
        );
      },
    );
  }

  Widget _section({
    required String title,
    required List<DashboardBalanceByFarm> items,
    bool loading = false,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            BasicTitle(text: title),
            ...items.asMap().entries.map(
              (entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;

                return Padding(
                  padding: isLast
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(bottom: 8),
                  child: BasicCard(
                    title: item.name,
                    icon: const Icon(
                      Icons.agriculture_rounded,
                      color: AppColors.primaryColorDark,
                      size: 24,
                    ),
                    items: [
                      CardSingleItem(
                        title: 'Inscrição',
                        value: Text(
                          item.inscription,
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CardSingleItem(
                        title: 'Sacas',
                        value: Text(
                          item.balance.toString(),
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CardSingleItem(
                        title: 'Bloqueado',
                        value: Text(
                          item.blocked.toString(),
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
