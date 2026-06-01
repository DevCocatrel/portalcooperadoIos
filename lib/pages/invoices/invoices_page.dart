import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/models/invoice_model.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:cocatrel/pages/invoices/invoices_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InvoicesPage extends StatelessWidget {
  InvoicesPage({super.key});

  final invoicesController = InvoicesController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: invoicesController,
      child: DefaultScaffoldWidget(
        drawer: const BasicMenuDrawer(),
        appBar: const ProfileAppBar(
          title: 'Boletos',
        ),
        body: Consumer<InvoicesController>(builder: (context, controller, _) {
          return Skeletonizer(
            enabled: controller.loading,
            child: RefreshIndicator(
              onRefresh: controller.fetchInvoices,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: controller.invoices.isLeft
                    ? [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child:
                              BasicCardError(error: 'Erro ao carregar dados'),
                        )
                      ]
                    : [
                        const Padding(
                          padding: EdgeInsets.only(top: 32, bottom: 16),
                          child: Text('Boletos Disponíveis'),
                        ),
                        if (controller.invoices.right.invoices?.isEmpty ??
                            false) ...{
                          const BasicCardError(
                              error: 'Não há boletos para listar')
                        },
                        ...(controller.invoices.right.invoices ?? [])
                            .map((item) => invoiceCardWidget(item)),
                      ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget invoiceCardWidget(InvoiceModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DefaultCardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.article_outlined,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title ?? '',
                    style: AppFonts.title.copyWith(
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            RowWithDataWidget(
              title: 'Vencimento',
              value: normalizeDate(item.dueDate ?? ''),
            ),
            const DividerCardWidget(),
            RowWithDataWidget(
              title: 'Valor',
              value: Currency.format(item.invoiceAmount ?? .0),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                launchUrlString(
                  item.invoiceLink ?? '',
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.buttonTextLight,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text('Baixar boleto', style: AppFonts.textButton),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
