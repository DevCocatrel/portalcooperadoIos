import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/market_navigation.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/dashboard_quotes.dart';
import 'package:cocatrel/pages/dashboard/home/widgets/commodities_section.dart';
import 'package:cocatrel/pages/dashboard/home/widgets/quotes_section.dart';
import 'package:cocatrel/repositories/dashboard_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class CoffeeExchangePage extends StatefulWidget {
  const CoffeeExchangePage({super.key});

  @override
  State createState() => _CoffeeExchangePageState();
}

class _CoffeeExchangePageState extends State<CoffeeExchangePage> {
  Either<Error, DashboardQuotes>? _quotes;

  Future<void> _loadCoffeeExchangeData() async {
    setState(() {
      _quotes = null;
    });

    final quotes = await DashboardRepository.loadQuotes();

    setState(() {
      _quotes = quotes;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCoffeeExchangeData();
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
        onRefresh: _loadCoffeeExchangeData,
        displacement: 50,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 32),
                    const CommoditiesSection(),
                    const SizedBox(height: 20),
                    QuotesSection(quotes: _quotes),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
