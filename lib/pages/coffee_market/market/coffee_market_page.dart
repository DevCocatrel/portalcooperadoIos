import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/market_navigation.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/core/utils/hex_to_color.dart';
import 'package:cocatrel/models/coffee_market_page_model.dart';
import 'package:cocatrel/repositories/coffee_market_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CoffeeMarketPage extends StatefulWidget {
  const CoffeeMarketPage({super.key});

  @override
  CoffeeMarketPageState createState() => CoffeeMarketPageState();
}

class CoffeeMarketPageState extends State<CoffeeMarketPage> {
  String? dialogSelectedDate;
  String? selectedDate;
  List<CoffeeMarketQuoteItemModel> quotes = [];
  Either<Error, CoffeeMarketPageModel>? _page;
  Either<Error, CoffeeMarketPageModel>? _pageByDate;

  Future<void> _loadPage() async {
    setState(() {
      _page = null;
      _pageByDate = null;
    });

    final page = await CoffeeMarketRepository.loadPage();

    selectedDate = page.isRight ? normalizeDate(page.right.quoteDate) : null;
    quotes = page.isRight ? page.right.quotes : [];
    dialogSelectedDate = selectedDate;

    if (page.isRight) {
      final pageByDate = await CoffeeMarketRepository.loadPageByDate(
        normalizeDate(page.right.quoteDate),
      );

      if (pageByDate.isRight) {
        quotes = pageByDate.right.quotes;
      }
    }

    setState(() {
      _page = page;
      _pageByDate = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  void updateDate(String? date) {
    setState(() {
      selectedDate = date;
    });
  }

  void updateDialogDate(String? date) {
    setState(() {
      dialogSelectedDate = date;
    });
  }

  Future<void> updateQuotesByDate(String? date) async {
    setState(() {
      _pageByDate = null;
    });

    final page = await CoffeeMarketRepository.loadPageByDate(date ?? "");

    if (page.isRight) {
      quotes = page.right.quotes;
    } else {
      quotes = [];
    }

    setState(() {
      _pageByDate = page;
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 32),
                  _title(),
                  const SizedBox(height: 16),
                  _warning(),
                  const SizedBox(height: 8),
                  _section(),
                  const SizedBox(height: 32),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _section() {
    if (_page == null) {
      return Skeletonizer(
          child: _content(
        page: CoffeeMarketPageModel(
          quoteDate: "2021-01-01",
          cooperateName: "Lorem Ipsum",
          quotes: List.generate(5, (index) {
            return CoffeeMarketQuoteItemModel(
              name: "Lorem Ipsum",
              percentage: "100%",
              price: 100.0,
              backgroundColor: "#000000",
              textColor: "#FFFFFF",
              date: "2021-01-01",
              priceWithCMS: 120.0,
            );
          }),
          dates: [],
          variations: [],
        ),
      ));
    }

    return _page!.fold(
      (error) => const BasicCardError(
        error: "Ocorreu um erro ao carregar a página. Tente novamente.",
      ),
      (page) => _content(page: page),
    );
  }

  Widget _content({
    CoffeeMarketPageModel? page,
  }) {
    return Column(
      children: [
        _selector(
          context,
          page: page,
        ),
        const SizedBox(height: 26),
        const BasicTitle(text: "Preço da classificação"),
        _listQuotes()
      ],
    );
  }

  Widget _listQuotes() {
    return Skeletonizer(
      enabled: _pageByDate == null,
      child: Column(
        children: [
          ...quotes.asMap().entries.map((entry) {
            final index = entry.key;
            final quote = entry.value;
            final price = Currency.format(quote.price);
            final priceWithCMS = Currency.format(quote.priceWithCMS);
            final isLast = index == quotes.length - 1;

            return Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 8,
              ),
              child: DefaultCardWidget(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: ColorTransform.hexToColor(
                                  quote.backgroundColor,
                                  defaultColor: AppColors.primaryDark,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 32,
                              width: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              quote.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Catação",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColorLight,
                                  ),
                                ),
                                Text(
                                  quote.percentage,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preço sem ICMS",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColorLight,
                              ),
                            ),
                            Text(
                              price,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Preço com ICMS",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColorLight,
                              ),
                            ),
                            Text(
                              priceWithCMS,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _selector(
    BuildContext context, {
    CoffeeMarketPageModel? page,
  }) {
    var date = normalizeDate(selectedDate ?? "Selecione a data");

    return DefaultCardWidget(
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
                  "Selecione a data da cotação",
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
                _showDatePicker(context);
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
                      date,
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
                "Os preços dos cafés COC-CDT, COC-CD1 e COC-CD2 serão avaliados de acordo com a qualidade",
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

  void _showDatePicker(BuildContext context) async {
    var dates = _page?.right.dates ?? [];

    DateTime? dateFist;
    DateTime? dateLast;

    if (dates.isNotEmpty) {
      final dateTimeList = dates.map((item) => item.dateTime).toList();
      dateFist = _page!.right.dates.last.dateTime;
      dateLast = _page!.right.dates.first.dateTime;

      DateTime initialDate = dateLast;

      final where =
          _page!.right.dates.where((item) => item.date == dialogSelectedDate);

      if (where.isNotEmpty) {
        initialDate = where.first.dateTime;
      }

      final date = await showDatePicker(
        context: context,
        firstDate: dateFist,
        lastDate: dateLast,
        initialDate: initialDate,
        selectableDayPredicate: (date) {
          return dateTimeList.contains(date);
        },
      );

      if (date != null) {
        dialogSelectedDate = DateFormat('dd/MM/yyyy').format(date);

        updateDate(dialogSelectedDate);
        await updateQuotesByDate(dialogSelectedDate);
      }

      return;
    }
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Classificações",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.coffeeSubtitles);
          },
          child: const Icon(
            Icons.subtitles_outlined,
            color: AppColors.primaryDark,
            size: 28,
          ),
        ),
      ],
    );
  }
}
