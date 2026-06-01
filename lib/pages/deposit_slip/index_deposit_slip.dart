import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/deposit_slip_navigation.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/invoice_list/invoice_list_tab.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/issue_invoice_page.dart';
import 'package:flutter/material.dart';

class IndexDepositSlip extends StatefulWidget {
  const IndexDepositSlip({super.key});

  @override
  State<IndexDepositSlip> createState() => _IndexDepositSlipState();
}

class _IndexDepositSlipState extends State<IndexDepositSlip>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      drawer: const BasicMenuDrawer(),
      appBar: const ProfileAppBar(title: 'Guia de depósito'),
      body: TabBarView(
        controller: tabController,
        children: [
          IssueInvoiceTab(
            (int toTab) {
              setState(() {
                tabController.animateTo(toTab);
              });
            },
          ),
          InvoiceListTab(),
        ],
      ),
      bottomNavigationBar: DepositSlipNavigationBar(
        tabController,
        (value) {
          if (tabController.index == value) {
            return;
          }
          setState(() {
            tabController.animateTo(value);
          });
        },
      ),
    );
  }
}
