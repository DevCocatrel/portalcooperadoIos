import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/dashboard_navigation.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:cocatrel/pages/dashboard/sales/widgets/authorizations_section.dart';
import 'package:cocatrel/pages/dashboard/sales/widgets/certifies_section.dart';
import 'package:cocatrel/repositories/dashboard_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  SalesPageState createState() => SalesPageState();
}

class SalesPageState extends State<SalesPage> {
  Either<Error, DashboardData>? data;

  Future<void> _loadDashboardData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        data = null;
      });

      final page = await DashboardRepository.loadPage();

      setState(() {
        data = page;
      });
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
                AuthorizationSection(data: data),
                const SizedBox(height: 26),
                CertifiesSection(data: data),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
