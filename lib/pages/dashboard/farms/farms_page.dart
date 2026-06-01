import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/dashboard_navigation.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:cocatrel/pages/dashboard/farms/widgets/balance_coffee_by_farm_section.dart';
import 'package:cocatrel/pages/dashboard/farms/widgets/balance_grains_by_farm_section.dart';
import 'package:cocatrel/repositories/dashboard_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class FarmsPage extends StatefulWidget {
  const FarmsPage({super.key});

  @override
  FarmsPageState createState() => FarmsPageState();
}

class FarmsPageState extends State<FarmsPage> {
  Either<Error, DashboardData>? data;

  Future<void> _loadDashboardData() async {
    setState(() {
      data = null;
    });

    final page = await DashboardRepository.loadPage();

    setState(() {
      data = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(),
      bottomNavigationBar: const DashboardNavigation(),
      drawer: const BasicMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 32),
                BalanceCoffeeByFarmSection(coffeeByFarm: data),
                const SizedBox(height: 26),
                BalanceGrainsByFarmSection(grainsByFarm: data),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
