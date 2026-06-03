import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/market_navigation.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeeExplanationPage extends StatefulWidget {
  const CoffeeExplanationPage({super.key});

  @override
  State createState() => _CoffeeExplanationPageState();
}

class _CoffeeExplanationPageState extends State<CoffeeExplanationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(
        title: "Mercado de Café",
      ),
      bottomNavigationBar: const MarketNavigation(),
      drawer: const BasicMenuDrawer(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 32),
                  const BasicTitle(text: "Ágio / Deságio"),
                  _card(
                    icon: const Icon(
                      Icons.bar_chart_rounded,
                      size: 24,
                      color: AppColors.primaryDark,
                    ),
                    title: "Ágio / Deságio",
                    items: [
                      _Value(
                        label: "Menor que 10%, a cada 1%",
                        value: "5",
                      ),
                      _Value(
                        label: "Maior que 10%, a cada 1%",
                        value: "-5",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _card(
                    icon: const Icon(
                      Icons.water_drop_outlined,
                      size: 24,
                      color: AppColors.primaryDark,
                    ),
                    title: "Seca",
                    items: [
                      _Value(
                        label: "Acima de 12,5%",
                        value: "-10,00",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _card(
                    icon: const Icon(
                      Icons.apps_rounded,
                      size: 24,
                      color: AppColors.primaryDark,
                    ),
                    title: "Peneira",
                    items: [
                      _Value(
                        label: "Alta",
                        value: "10,00",
                      ),
                      _Value(
                        label: "Média Alta",
                        value: "5,00",
                      ),
                      _Value(
                        label: "Média Safra",
                        value: "0,00",
                      ),
                      _Value(
                        label: "Média Baixa",
                        value: "-5,00",
                      ),
                      _Value(
                        label: "Baixa",
                        value: "-10,00",
                      ),
                      _Value(
                        label: "Safra 2026/2027",
                        value: "-100,00",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _card(
                    icon: const Icon(
                      Icons.agriculture_outlined,
                      size: 24,
                      color: AppColors.primaryDark,
                    ),
                    title: "Safra",
                    items: [
                      _Value(
                        label: "Safra 2024/2025",
                        value: "-20,00",
                      ),
                      _Value(
                        label: "Safras anteriores",
                        value: "-20,00",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _card(
                    showWarning: true,
                    icon: const Icon(
                      Icons.trending_down_rounded,
                      size: 24,
                      color: AppColors.primaryDark,
                    ),
                    title: "Cafés Baixos",
                    items: [
                      _Value(
                        label: "COC 13 Bica Repasse",
                        value: "0,00",
                      ),
                      _Value(
                        label: "COC 13 Repasse",
                        value: "-10,00",
                      ),
                      _Value(
                        label: "COC 13 Bica Resíduo",
                        value: "-10,00",
                      ),
                      _Value(
                        label: "COC 13 Resíduo",
                        value: "-20,00",
                      ),
                    ],
                  ),
                  const SizedBox(height: 32)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required Widget icon,
    required List<_Value> items,
    bool showWarning = false,
  }) {
    return DefaultCardWidget(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == items.length - 1;
                  final isFirst = index == 0;

                  return Container(
                    padding: EdgeInsets.only(
                      bottom: isLast ? 0 : 8,
                      top: isFirst ? 0 : 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isLast
                              ? Colors.transparent
                              : AppColors.borderColor,
                          width: isLast ? 0 : 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              item.label,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColorLight,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              item.value,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColorLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })
              ],
            ),
            if (showWarning) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 22,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "COC 14 - Preço será calculado com base no aproveitamento da escolha (1% a 100%)",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColorLight,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              )
            ],
          ],
        ),
      ),
    );
  }
}

class _Value {
  final String label;
  final String value;

  _Value({
    required this.label,
    required this.value,
  });
}
