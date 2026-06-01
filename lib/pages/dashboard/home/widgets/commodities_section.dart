import 'dart:async';

import 'package:cocatrel/common/widgets/cards/basic/basic_card.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/models/dashboard_commoditie.dart';
import 'package:cocatrel/models/dashboard_commodities.dart';
import 'package:cocatrel/repositories/dashboard_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommoditiesSection extends StatefulWidget {
  const CommoditiesSection({super.key});

  @override
  State createState() => _CommoditiesSectionState();
}

class _CommoditiesSectionState extends State<CommoditiesSection> {
  Either<Error, DashboardCommodities>? commodities;
  bool loading = true;

  Future<void> _initLoadCommodities() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        loading = true;
      });

      final response = await DashboardRepository.loadCommodities();

      setState(() {
        commodities = response;
        loading = false;
      });

      _startTimer();
    });
  }

  Future<void> _loadCommodities() async {
    final response = await DashboardRepository.loadCommodities();
    commodities = response;
    if (mounted) {
      setState(() {});
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 10), () {
      _loadCommodities().then((_) {
        _startTimer();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initLoadCommodities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const title = "Bolsas de commodities";

    if (loading) {
      return _section(
        loading: true,
        title: title,
        subTitle: "00/00/00 00:00",
        commodities: List.generate(2, (index) {
          return DashboardCommoditie(
            contract: "Lorem",
            contractDescription: "Lorem Ipsum Dolor",
            difference: 0.00,
            value: 0.00,
            percentage: 0.00,
            position: "D",
          );
        }),
      );
    }

    return commodities!.fold(
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
                error: "Erro ao carregar commodities",
              ),
            ],
          ),
        );
      },
      (commodities) {
        final date = normalizeDate(
          commodities.dateHourCommoditie,
        );

        if (commodities.commodities.isEmpty) {
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
                  error: "Nenhuma commodity disponível",
                ),
              ],
            ),
          );
        }

        return _section(
          title: title,
          subTitle: date,
          commodities: commodities.commodities,
        );
      },
    );
  }

  Widget _section({
    bool loading = false,
    required String title,
    required String subTitle,
    required List<DashboardCommoditie> commodities,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 16, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColorDark,
                    ),
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        subTitle,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: commodities.asMap().entries.map((item) {
                final index = item.key;
                var contractName = item.value.contractDescription;
                var contract = item.value.contract;
                var percentage = item.value.percentage;
                var difference = item.value.difference;
                var value = item.value.value;

                return Padding(
                  padding:
                      EdgeInsets.only(right: 20, left: index == 0 ? 20 : 0),
                  child: BasicCard(
                    title: contractName,
                    icon: const Icon(
                      Icons.attach_money_rounded,
                      size: 24,
                      color: AppColors.primaryColorDark,
                    ),
                    items: [
                      CardSingleItem(
                        title: contract,
                        value: Text(
                          value.toString(),
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CardSingleItem(
                        title: "DIF",
                        value: Text(
                          difference.toString(),
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CardSingleItem(
                        title: "",
                        value: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$percentage",
                              style: GoogleFonts.montserrat(
                                color: percentage >= 0
                                    ? AppColors.success
                                    : AppColors.danger,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              size: 22,
                              percentage >= 0
                                  ? Icons.arrow_drop_up_outlined
                                  : Icons.arrow_drop_down_outlined,
                              color:
                                  percentage >= 0 ? Colors.green : Colors.red,
                            )
                          ],
                        ),
                      )
                    ],
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
