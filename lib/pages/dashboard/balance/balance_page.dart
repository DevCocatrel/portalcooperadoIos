import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/dashboard_navigation.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:cocatrel/pages/dashboard/balance/widgets/balance_by_classification_section.dart';
import 'package:cocatrel/pages/dashboard/balance/widgets/balance_harvest_section.dart';
import 'package:cocatrel/pages/dashboard/balance/widgets/balance_section.dart';
import 'package:cocatrel/pages/dashboard/balance/widgets/harvest_section.dart';
import 'package:cocatrel/repositories/dashboard_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => BalancePageState();
}

class BalancePageState extends State<BalancePage> {
  Either<Error, DashboardData>? _dashboardData;

  Future<void> _loadPage() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _dashboardData = null;
      if (mounted) {
        setState(() {});
      }

      final data = await DashboardRepository.loadPage();

      _dashboardData = data;

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(),
      bottomNavigationBar: const DashboardNavigation(),
      drawer: const BasicMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadPage,
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
                    BalanceSection(balance: _dashboardData),
                    const SizedBox(height: 26),
                    HarvestSection(data: _dashboardData),
                    const SizedBox(height: 26),
                    BalanceHarvestSection(data: _dashboardData),
                    const SizedBox(height: 26),
                    BalanceByClassificationSection(data: _dashboardData),
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
}
