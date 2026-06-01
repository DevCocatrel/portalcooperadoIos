import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/dashboard_navigation.dart';
import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_controller.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:cocatrel/models/dashboard_quotes.dart';
import 'package:cocatrel/pages/dashboard/home/widgets/panel_section.dart';
import 'package:cocatrel/pages/dashboard/home/widgets/commodities_section.dart';
import 'package:cocatrel/pages/dashboard/home/widgets/quotes_section.dart';
import 'package:cocatrel/repositories/dashboard_repository.dart';
import 'package:either_dart/either.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const modalLink = 'https://forms.gle/NrDA7mLPHdpfcgin8';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Either<Error, DashboardData>? _panel;
  Either<Error, DashboardQuotes>? _quotes;

  Future<void> _loadDashboardData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _panel = null;
        _quotes = null;
      });

      final [
        panel as Either<Error, DashboardData>,
        quotes as Either<Error, DashboardQuotes>,
      ] = await Future.wait([
        DashboardRepository.loadPage(),
        DashboardRepository.loadQuotes(),
      ]);

      _panel = panel;
      _quotes = quotes;
      if (context.mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _showModal({String? link}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (context) {
        return Dialog(
          elevation: 40,
          shadowColor: Colors.black.withValues(alpha: .7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.asset(
                    link != null ? AppAssets.modalWithLink : AppAssets.modal,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 8,
                    children: [
                      if (link != null)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            launchUrlString(
                              modalLink,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: Text(
                            'Responder pesquisa',
                            style: AppFonts.textButton.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "Fechar",
                          style: AppFonts.textButton.copyWith(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AppController>().showModal) {
        verifyShowModals();
      }
    });
  }

  verifyShowModals() async {
    final now = DateTime.now();
    var deadLine = DateTime(2025, 11, 24, 23, 59, 59);

    final showModal =
        now.millisecondsSinceEpoch <= deadLine.millisecondsSinceEpoch;

    await Future.delayed(const Duration(milliseconds: 500));

    if (showModal) {
      await _showModal(link: null);
    }

    App.checkVersionUpdate();
    if (mounted) {
      context.read<AppController>().markAsSeenModalUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(
        isHomePage: true,
      ),
      bottomNavigationBar: const DashboardNavigation(),
      drawer: const BasicMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
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
                    PanelSection(panel: _panel),
                    const SizedBox(height: 20),
                    QuotesSection(quotes: _quotes),
                    const SizedBox(height: 20),
                    const CommoditiesSection(),
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
