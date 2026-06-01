import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/authorization_sale_navigation.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/authorization_sale_page_model.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/list_lots_by_farm_id_controller.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sale_controller.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sections/analysis/sale_analysis_section.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sections/confirmation/sale_confirmation_section.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sections/payment/sale_payment_section.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sections/profile/sale_profile_section.dart';
import 'package:cocatrel/repositories/authorization_sales_repository.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthorizationSalePage extends StatefulWidget {
  final double openTitles;
  final AuthorizationSaleFarmBalanceModel farm;
  final List<AuthorizationItem> batches;

  const AuthorizationSalePage({
    super.key,
    required this.batches,
    required this.farm,
    required this.openTitles,
  });

  @override
  State createState() => _AuthorizationSalePageState();
}

class _AuthorizationSalePageState extends State<AuthorizationSalePage> {
  late final SalePageController controller;

  @override
  void initState() {
    super.initState();

    controller = SalePageController(
      openTitles: widget.openTitles,
      batches: widget.batches,
      farm: widget.farm,
      bankAccounts: [],
    );

    loadBankAccounts();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<void> loadBankAccounts() async {
    final response = await AuthorizationSalesRepository.loadPage();

    if (response.isRight) {
      controller.setBankAccounts(response.right.bankAccounts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(
        showBackButton: true,
      ),
      bottomNavigationBar: const AuthorizationSaleNavigation(),
      drawer: const BasicMenuDrawer(),
      body: ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<SalePageController>(
          builder: (context, controller, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 32),
                        _stepper(),
                        _stepContent(controller.currentStep),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getContentForStep(int step) {
    switch (step) {
      case 0:
        return const SaleAnalysisSection();
      case 1:
        return const SaleProfileSection();
      case 2:
        return SalePaymentSection();
      case 3:
        return SaleConfirmationSection();
      default:
        return const SaleAnalysisSection();
    }
  }

  //analysis

  Widget _stepContent(int step) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey<int>(step),
        child: _getContentForStep(step),
      ),
    );
  }

  Widget _stepper() {
    return EasyStepper(
      activeStep: controller.currentStep,
      enableStepTapping: true,
      lineStyle: const LineStyle(
        activeLineColor: AppColors.borderColor,
        defaultLineColor: AppColors.borderColor,
        lineType: LineType.normal,
        lineThickness: 2,
        finishedLineColor: AppColors.primaryColor,
      ),
      finishedStepBackgroundColor: Colors.transparent,
      internalPadding: 8,
      showLoadingAnimation: false,
      showStepBorder: false,
      disableScroll: true,
      steppingEnabled: false,
      onStepReached: (index) {
        controller.setStep(index);
      },
      steps: [
        _step(0, label: "1"),
        _step(1, label: "2"),
        _step(2, label: "3"),
        _step(3, label: "4"),
      ],
    );
  }

  EasyStep _step(int index, {required String label}) {
    return EasyStep(
      customStep: Container(
        width: 42,
        height: 42,
        transformAlignment: Alignment.center,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: controller.currentStep == index
              ? Colors.transparent
              : controller.currentStep > index
                  ? AppColors.primaryColor
                  : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: controller.currentStep >= index
                ? AppColors.primaryColor
                : AppColors.borderColor,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: controller.currentStep == index
                ? AppColors.primaryColor
                : controller.currentStep > index
                    ? AppColors.backgroundColor
                    : AppColors.textColorLight,
          ),
        ),
      ),
    );
  }
}
