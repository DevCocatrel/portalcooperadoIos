import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sale_controller.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sections/payment/sale_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SalePaymentSection extends StatelessWidget {
  final SalePaymentController controller = SalePaymentController();

  SalePaymentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var saleController =
        Provider.of<SalePageController>(context, listen: false);

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<SalePaymentController>(
        builder: (context, value, child) {
          return Form(
            key: controller.formKey,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sobre o pagamento',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 26),
                  DefaultCardWidget(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money_rounded,
                                color: AppColors.primaryDark,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Pagamento",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "O pagamento sera creditado em sua Conta Corrente selecionada abaixo",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColorLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            children: [
                              DropdownButtonFormField(
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 24,
                                  color: AppColors.textColor,
                                ),
                                hint: Text(
                                  saleController.showSelectedAccount ??
                                      "Selecione o banco e conta",
                                  style: AppFonts.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: AppColors.borderColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                items: const [],
                                validator: (value) {
                                  if (saleController.selectedAccount == null) {
                                    return "Selecione o banco";
                                  }

                                  return null;
                                },
                                onChanged: (_) {},
                              ),
                              Positioned.fill(
                                child: InkWell(
                                  onTap: () {
                                    final oldValue =
                                        saleController.selectedAccount;
                                    showOptionsDialog(
                                      context,
                                      title: 'Selecione o banco e conta',
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            saleController
                                                .setSelectedAccount(oldValue);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Cancelar',
                                            style: AppFonts.textButton,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Selecionar',
                                            style: AppFonts.textButton,
                                          ),
                                        ),
                                      ],
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: ChangeNotifierProvider.value(
                                          value: saleController,
                                          child: Consumer<SalePageController>(
                                              builder:
                                                  (context, saleController, _) {
                                            return Column(
                                              children: [
                                                ...saleController.bankAccounts
                                                    .asMap()
                                                    .entries
                                                    .map((item) {
                                                  final splicedId =
                                                      item.value.id.split(';');
                                                  return Column(
                                                    children: [
                                                      if (item.key > 0)
                                                        const DividerCardWidget(),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "${splicedId[2]} - ${item.value.bank}",
                                                            ),
                                                          ),
                                                          Radio(
                                                            value: item.value,
                                                            groupValue:
                                                                saleController
                                                                    .selectedAccount,
                                                            onChanged:
                                                                saleController
                                                                    .setSelectedAccount,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  saleController.previousStep();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Voltar',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.buttonTextLight,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    saleController.nextStep();
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Próximo',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.buttonTextLight,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.buttonTextLight,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
