import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicChartDot {
  final String label;
  final double value;

  BasicChartDot({
    required this.label,
    required this.value,
  });
}

class BasicLineChart extends StatelessWidget {
  final List<BasicChartDot> dots;
  final Color chartColor;
  late final List<Color> gradientColors;
  late final List<Color> belowBarColors;

  BasicLineChart({
    super.key,
    required this.dots,
    required this.chartColor,
  }) {
    gradientColors = [
      chartColor,
      chartColor,
    ];

    belowBarColors = [
      chartColor.withValues(alpha: 0.5),
      chartColor.withValues(alpha: 0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (dots.isEmpty) {
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
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: chartColor,
                      strokeWidth: 2,
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: chartColor,
                        );
                      },
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (spot) => AppColors.backgroundColor,
                tooltipPadding: const EdgeInsets.all(4),
                tooltipBorder: const BorderSide(
                  color: AppColors.borderColor,
                  width: 1,
                ),
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    return LineTooltipItem(
                      '${touchedSpot.y}',
                      GoogleFonts.montserrat(
                        color: AppColors.textColorLight,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
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
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  maxIncluded: true,
                  minIncluded: false,
                  getTitlesWidget: (
                    double value,
                    TitleMeta meta,
                  ) {
                    return leftTitleWidgets(
                      value,
                      meta,
                      getListOfValues(),
                    );
                  },
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            minX: 0,
            maxX: dots.length > 1 ? dots.length.toDouble() - 1 : 1,
            minY: 0,
            maxY: dots.length > 1 ? getHigherValue() : getHigherValue() + 1,
            lineBarsData: [
              LineChartBarData(
                spots: getSpots(),
                isCurved: true,
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: belowBarColors,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> getSpots() {
    final spots = <FlSpot>[];
    for (var i = 0; i < dots.length; i++) {
      spots.add(FlSpot(i.toDouble(), dots[i].value));
    }
    return spots;
  }

  double getHigherValue() {
    if (dots.isEmpty) return 1;

    return dots.map((e) => e.value).reduce((a, b) => a > b ? a : b);
  }

  double getLowerValue() {
    if (dots.isEmpty) return 1;

    return dots.map((e) => e.value).reduce((a, b) => a < b ? a : b);
  }

  double getSpacer() {
    if (dots.length <= 1) return 1;

    double higherValue = getHigherValue();

    if (higherValue < 500) {
      return 50;
    }

    double lowerValue = getLowerValue();
    double difference = higherValue - lowerValue;

    if (difference == 0) return 1; // Prevent division by zero

    var space = double.parse(
      (difference / dots.length).toStringAsFixed(0),
    );

    return (space / 500).ceil() * 500;
  }

  double getLowerValueBySpacer() {
    if (dots.length <= 1) return getLowerValue();

    double spacer = getSpacer();
    if (spacer == 0) return getLowerValue();

    return (getLowerValue() / spacer).floor() * spacer;
  }

  double getHigherValueBySpacer() {
    if (dots.length <= 1) return getHigherValue();

    double spacer = getSpacer();
    if (spacer == 0) return getHigherValue();

    return (getHigherValue() / spacer).ceil() * spacer;
  }

  List<double> getListOfValues() {
    List<double> values = [];
    double minValue = getLowerValueBySpacer();
    double maxValue = getHigherValueBySpacer();
    double spacer = getSpacer();

    for (double i = minValue; i <= maxValue; i += spacer) {
      values.add(double.parse(i.toStringAsFixed(0)));
    }

    return values;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() < 0 || value.toInt() >= dots.length) {
      return Container();
    }

    return Text(
      dots[value.toInt()].label,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        fontSize: 10,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget leftTitleWidgets(
    double value,
    TitleMeta meta,
    List<double> values,
  ) {
    int index = values.indexOf(double.parse(value.toStringAsFixed(0)));

    if (index == -1) {
      return Container();
    }

    String text = value.toStringAsFixed(0);

    return SideTitleWidget(
      meta: meta,
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }
}
