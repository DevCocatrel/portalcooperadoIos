import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/title/title_with_icon_card_widget.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/invoice_list/invoice_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InvoiceListTab extends StatelessWidget {
  InvoiceListTab({super.key});

  final invoiceListController = InvoiceListController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: invoiceListController,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<InvoiceListController>(
          builder: (context, controller, _) {
            return Skeletonizer(
              enabled: controller.loading,
              child: RefreshIndicator(
                onRefresh: controller.fetchLastInvoiceList,
                child: ListView(
                  children: [
                    const SizedBox(height: 32),
                    const Text('Últimas Notas Fiscais Emitidas'),
                    const SizedBox(height: 16),
                    DefaultCardWidget(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_sharp,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'O PDF pode levar até 2 minutos para ser gerado, caso não seja gerado contate a Cocatrel pelo telefone (35)3266-8200.',
                              style: AppFonts.text.copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.lastInvoiceList.isRight) ...{
                      ...(controller.lastInvoiceList.right.nfeList ?? []).map(
                        (item) => DefaultCardWidget(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TitleWithIconCardWidget(
                                      title: item.documentNumber ?? '',
                                      icon: Icons.article_outlined,
                                    ),
                                  ),
                                  item.statusFlag == 'Autorizada'
                                      ? Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: AppColors.successLight,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.check,
                                                color: AppColors.successDark,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Autorizada',
                                                style: AppFonts.textButton
                                                    .copyWith(
                                                  color: AppColors.successDark,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: AppColors.dangerLight,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.error_outline,
                                                color: AppColors.dangerDark,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Cancelada',
                                                style: AppFonts.textButton
                                                    .copyWith(
                                                  color: AppColors.dangerDark,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              RowWithDataWidget(
                                title: 'Data de emissão',
                                value:
                                    normalizeDate(item.registrationDate ?? ''),
                              ),
                              const DividerCardWidget(),
                              if ((item.cancellationDate ?? '').isNotEmpty) ...{
                                RowWithDataWidget(
                                  title: 'Data de cancelamento',
                                  value: normalizeDate(
                                      item.cancellationDate ?? ''),
                                ),
                                const DividerCardWidget(),
                              },
                              RowWithDataWidget(
                                title: 'Fazenda',
                                value: item.farmName ?? '',
                              ),
                              const DividerCardWidget(),
                              RowWithDataWidget(
                                title: 'Sacas',
                                value: item.bags ?? '',
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showDefaultDialog(
                                        context,
                                        title:
                                            'Chave NFE ${item.documentNumber ?? ''}',
                                        contentText:
                                            item.accessKeyNumber ?? ',',
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                Navigator.of(context).pop,
                                            child: Text(
                                              'Fechar',
                                              style: AppFonts.textButton,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              if ((item.accessKeyNumber ?? '')
                                                  .isNotEmpty) {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: item
                                                            .accessKeyNumber!));
                                                successSnackBar(
                                                    'Chave NFE copiada para a área de transferência');
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Copiar',
                                                  style: AppFonts.textButton,
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(
                                                  Icons.copy_rounded,
                                                  color:
                                                      AppColors.buttonTextLight,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.visibility_outlined,
                                          color: AppColors.buttonTextLight,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Chave NFE',
                                          style: TextStyle(
                                            color: AppColors.buttonTextLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (item.statusFlag == 'Autorizada')
                                    InkWell(
                                      onTap: () {
                                        controller.downloadInvoicePdf(item);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.primaryColor,
                                        ),
                                        padding: const EdgeInsets.all(9),
                                        child: controller.loadingDownloadNFE ==
                                                item.accessKeyNumber
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.file_download_outlined,
                                                color:
                                                    AppColors.buttonTextLight,
                                              ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    },
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
