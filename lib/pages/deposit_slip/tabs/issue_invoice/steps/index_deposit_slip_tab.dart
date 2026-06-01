import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/issuer_identification/issuer_identification_tab.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/coffee_information_page/coffee_information_tab.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/delivery_information/delivery_information_tab.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/issue_invoice_index_steps_controller.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/resume/resume_tab.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/transport_identification/transport_identification_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IssueInvoiceStepsPage extends StatefulWidget {
  const IssueInvoiceStepsPage(this.depositSlip, {super.key});

  final DepositSlip depositSlip;

  @override
  State<IssueInvoiceStepsPage> createState() => _IssueInvoiceStepsPageState();
}

class _IssueInvoiceStepsPageState extends State<IssueInvoiceStepsPage>
    with SingleTickerProviderStateMixin {
  late IssueInvoiceIndexController indexController;

  @override
  void initState() {
    super.initState();
    indexController = IssueInvoiceIndexController(
        widget.depositSlip, TabController(length: 5, vsync: this));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: indexController,
      child: DefaultScaffoldWidget(
        drawer: const BasicMenuDrawer(),
        appBar: ProfileAppBar(
          showBackButton: true,
          goBackFunction: () {
            var currentIndex = indexController.tabController.index;
            if (currentIndex > 0) {
              indexController.tabController.animateTo(currentIndex - 1);
            } else {
              final canPop = Navigator.of(context).canPop();

              if (canPop) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(), // Desabilita o swipe

            controller: indexController.tabController,
            children: [
              const IssuerIdentificationTab(),
              TransportIdentificationTab(indexController.depositSlip),
              CoffeeInformationTab(indexController.depositSlip),
              DeliveryInformationTab(indexController.depositSlip),
              ResumeTab(),
            ],
          ),
        ),
      ),
    );
  }
}
