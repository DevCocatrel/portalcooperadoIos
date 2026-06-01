import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/title/title_with_icon_card_widget.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:cocatrel/pages/deposit_slip/common/steps_widget.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/issue_invoice_index_steps_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IssuerIdentificationTab extends StatelessWidget {
  const IssuerIdentificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final indexController =
        Provider.of<IssueInvoiceIndexController>(context, listen: false);
    return Column(
      children: [
        const StepsWidget(1, 'Identificação do emissor'),
        DefaultCardWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TitleWithIconCardWidget(
                title: indexController.depositSlip.farm?.farmName ?? '',
                icon: Icons.agriculture_outlined,
              ),
              const SizedBox(height: 16),
              RowWithDataWidget(
                  title: 'Inscrição',
                  value: indexController.depositSlip.farm?.registrationNumber ??
                      ''),
              const DividerCardWidget(),
              RowWithDataWidget(
                  title: 'Código', value: auth.user?.registration ?? ''),
              const DividerCardWidget(),
              RowWithDataWidget(
                title: 'Cooperado',
                value: auth.user?.formattedName ?? '',
              ),
              const DividerCardWidget(),
              RowWithDataWidget(
                title: 'Data de emissão',
                value: DateFormat('dd/MM/yyyy').format(
                  DateTime.now(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  indexController.tabController.animateTo(1);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Próximo',
                      style: TextStyle(
                        color: AppColors.buttonTextLight,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_outlined,
                      color: AppColors.buttonTextLight,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
