import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/chart/basic_bar_chart.dart';
import 'package:cocatrel/common/widgets/chart/basic_line_chart.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BalanceHarvestSection extends StatelessWidget {
  final Either<Error, DashboardData>? data;

  const BalanceHarvestSection({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    const title = "Saldo por safra";

    if (data == null) {
      return _section(
        loading: true,
        title: title,
        harvests: List.generate(
          6,
          (index) {
            return BasicChartDot(
              label: "$index$index/$index$index",
              value: (1000 + index * 1000).toDouble(),
            );
          },
        ),
      );
    }

    return data!.fold((error) {
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
          ],
        ),
      );
    }, (data) {
      return _section(
        title: title,
        harvests: data.balanceHarvests
            .map((harvest) => BasicChartDot(
                  label: harvest.year,
                  value: harvest.quantity,
                ))
            .take(6)
            .toList(),
      );
    });
  }

  Widget _section({
    bool loading = false,
    required String title,
    required List<BasicChartDot> harvests,
  }) {
    var onlyOne = harvests.length == 1;

    return Skeletonizer(
      enabled: loading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BasicTitle(text: title),
            if (onlyOne)
              BasicBarChart(
                chartColor: AppColors.chartOrangeColor,
                items: List.generate(
                  harvests.length,
                  (index) {
                    return BasicBarChartItem(
                      label: harvests[index].label,
                      value: harvests[index].value,
                    );
                  },
                ),
              ),
            if (!onlyOne)
              BasicLineChart(
                dots: harvests,
                chartColor: AppColors.chartOrangeColor,
              ),
          ],
        ),
      ),
    );
  }
}
