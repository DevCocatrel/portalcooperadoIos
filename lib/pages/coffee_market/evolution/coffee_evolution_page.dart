import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/chart/basic_line_chart.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/dialog/basic_dialog.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/market_navigation.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/coffee_history_model.dart';
import 'package:cocatrel/models/coffee_market_page_model.dart';
import 'package:cocatrel/repositories/coffee_market_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

String convertQuoteCocToFilterInHistory(String value, {bool convert = true}) {
  final cocNumberAsString = value.split(" ")[1];
  final cocFormatted = (int.tryParse(cocNumberAsString) ?? 0);

  if (convert) {
    final cocSummed = (cocFormatted - 1) + 10;
    return cocSummed.toString();
  }

  return cocFormatted.toString();
}

class CoffeeEvolutionPage extends StatefulWidget {
  const CoffeeEvolutionPage({super.key});

  @override
  State createState() => _CoffeeEvolutionPageState();
}

class _CoffeeEvolutionPageState extends State<CoffeeEvolutionPage> {
  String? dialogSelectedQuote;
  String? selectedQuote;
  Either<Error, CoffeeMarketPageModel>? _page;
  Either<Error, List<CoffeeHistoryModel>>? _history;
  bool refreshingChart = false;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    setState(() {
      _page = null;
      _history = null;
    });

    final page = await CoffeeMarketRepository.loadPage();

    if (page.isRight) {
      var firstQuoteName = page.right.quotes.first.name;

      setState(() {
        dialogSelectedQuote = firstQuoteName;
        selectedQuote = firstQuoteName;
      });

      final history = await CoffeeMarketRepository.loadHistoryOfQuote(
        convertQuoteCocToFilterInHistory(firstQuoteName),
      );

      setState(() {
        _history = history;
      });
    }

    setState(() {
      _page = page;
    });
  }

  Future<void> _updateHistoryByQuote(String? quote) async {
    setState(() {
      refreshingChart = true;
    });

    if (quote == null) {
      return Future.value();
    }

    final response = await CoffeeMarketRepository.loadHistoryOfQuote(
      convertQuoteCocToFilterInHistory(quote),
    );

    setState(() {
      _history = response;
    });

    await throttleRefreshingChart();
  }

  Future<void> throttleRefreshingChart() {
    setState(() {
      refreshingChart = true;
    });

    return Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        refreshingChart = false;
      });
    });
  }

  void updateQuote(String? quote) {
    setState(() {
      selectedQuote = quote;
    });
  }

  void updateDialogQuote(String? quote) {
    setState(() {
      dialogSelectedQuote = quote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(
        title: "Mercado de Café",
      ),
      bottomNavigationBar: const MarketNavigation(),
      drawer: const BasicMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadPage,
        displacement: 50,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 32),
                    const BasicTitle(text: "Evolução do preço do café"),
                    _warning(),
                    const SizedBox(height: 16),
                    _sectionSelector(context),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Evolução",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                        if (refreshingChart) ...[
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
                        ]
                      ],
                    ),
                    const SizedBox(height: 16),
                    _sectionChart(),
                    const SizedBox(height: 32),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionSelector(BuildContext context) {
    if (_page == null) {
      return _selector(context, loading: true);
    }

    return _page!.fold((error) {
      return const BasicCardError(error: "Erro as catações");
    }, (data) {
      return _selector(context);
    });
  }

  Widget _selector(
    BuildContext context, {
    bool loading = false,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: DefaultCardWidget(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.schedule_outlined,
                    color: AppColors.primaryDark,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Selecione a classificação",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  _showDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dialogSelectedQuote ?? "Selecione",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_drop_down_outlined,
                        color: AppColors.textColorLight,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _warning() {
    return DefaultCardWidget(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.error_outline_outlined,
              color: AppColors.primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Esta evolução pega o preço dos últimos 30 dias da classificação COC 03",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionChart() {
    if (_history == null) {
      return _chart(
        List.generate(
          10,
          (index) {
            var price = (1000 - (index * 50)).toDouble();

            return CoffeeHistoryModel(
              date: "01/01",
              price: price,
              percentage: "10%",
            );
          },
        ),
      );
    }

    return _history!.fold((error) {
      return const BasicCardError(error: "Erro ao carregar o histórico");
    }, (data) {
      return _chart(data);
    });
  }

  Widget _chart(List<CoffeeHistoryModel> history) {
    final historyFormatted = history.sublist(0, 7);

    return Skeletonizer(
      enabled: _history == null,
      child: BasicLineChart(
        dots: historyFormatted.map(
          (history) {
            final dateSpliced = history.date.split("/");
            final day = dateSpliced[0];
            final month = dateSpliced[1];

            return BasicChartDot(
              label: "$day/$month",
              value: history.price,
            );
          },
        ).toList(),
        chartColor: AppColors.chartBlueColor,
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        var quotes = (_page?.right.quotes ?? []);

        return StatefulBuilder(
          builder: (context, setState) {
            return BasicAlertDialog(
              title: "Cotação",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selecione a data da cotação",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColorLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...quotes.asMap().entries.map(
                            (entry) {
                              final quote = entry.value;

                              return Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.borderColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  leading: Text(
                                    quote.name,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  trailing: Transform.scale(
                                    scale: 1.1,
                                    child: Radio(
                                      fillColor: WidgetStateProperty.all(
                                        quote.name == dialogSelectedQuote
                                            ? AppColors.primaryColor
                                            : AppColors.borderDarkColor,
                                      ),
                                      activeColor: AppColors.primaryColor,
                                      value: quote.name,
                                      groupValue: dialogSelectedQuote,
                                      onChanged: (value) {
                                        setState(() {
                                          dialogSelectedQuote = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              actions: [
                InkWell(
                  onTap: () {
                    updateDialogQuote(selectedQuote);

                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Text(
                      "Cancelar",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonTextLight,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    updateQuote(dialogSelectedQuote);
                    await _updateHistoryByQuote(dialogSelectedQuote);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      "Selecionar",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonTextLight,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
