import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicBarChartItem {
  final String label;
  final double value;

  BasicBarChartItem({
    required this.label,
    required this.value,
  });
}

class BasicBarChart extends StatelessWidget {
  final List<BasicBarChartItem> items;
  final Color chartColor;

  const BasicBarChart({
    super.key,
    required this.items,
    required this.chartColor,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return DefaultCardWidget(
        child: Center(
          child: Text(
            'Não há dados para exibir',
            style: GoogleFonts.montserrat(
              color: AppColors.textColorLight,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return DefaultCardWidget(
      child: AspectRatio(
        aspectRatio: 1.75,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 40.0 * constraints.maxWidth / 400;
            final barsWidth = 15.0 * constraints.maxWidth / 400;

            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.start,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (spot) => AppColors.backgroundColor,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        items[group.x.toInt()].value.toString(),
                        GoogleFonts.montserrat(
                          color: AppColors.textColorLight,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      );
                    },
                    tooltipPadding: const EdgeInsets.only(
                      top: 4,
                      bottom: 2,
                      left: 4,
                      right: 4,
                    ),
                    tooltipBorder: const BorderSide(
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                    fitInsideHorizontally: true,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      maxIncluded: true,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.borderColor.withValues(alpha: 0.30),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return List.generate(
      items.length,
      (index) {
        return BarChartGroupData(
          x: index,
          barsSpace: barsSpace,
          barRods: [
            BarChartRodData(
              toY: items[index].value,
              rodStackItems: [
                BarChartRodStackItem(0, items[index].value, chartColor),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              width: barsWidth,
            ),
          ],
        );
      },
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    if (value.toInt() < 0 || value.toInt() >= items.length) {
      return Container();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        items[value.toInt()].label,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toInt().toString(),
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }
}
