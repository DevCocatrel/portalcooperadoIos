import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/dialog/basic_dialog.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/validators/max_number_validator.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sale_controller.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sections/confirmation/dialog_controller.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sections/confirmation/sale_confirmation_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SaleConfirmationSection extends StatelessWidget {
  final DialogController dialogController = DialogController();
  final SaleConfirmationController controller = SaleConfirmationController();

  SaleConfirmationSection({super.key});

  @override
  Widget build(BuildContext context) {
    var saleController =
        Provider.of<SalePageController>(context, listen: false);

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<SaleConfirmationController>(
        builder: (context, value, child) {
          return Form(
            key: controller.formKey,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Considerações finais',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.done_all_rounded,
                                color: AppColors.primaryDark,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Confirmação",
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
                            "Precisa de um Adiantamento?",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColorLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!saleController.isAllowedToUseQuickMoney ==
                              true) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.error_outline_outlined,
                                  color: AppColors.primaryColor,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "* Amostras com preços PreFixado não são permitidos Adiantamento",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textColorLight,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                          const SizedBox(height: 16),
                          quickMoneyControl(context),
                          const SizedBox(height: 16),
                          _advanceMoney(
                            context,
                            show: saleController.isQuickMoney,
                          ),
                          _footerActions(context),
                          const SizedBox(height: 16),
                          _warnings(context),
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

  Widget _advanceMoney(
    BuildContext context, {
    bool show = false,
  }) {
    var saleController =
        Provider.of<SalePageController>(context, listen: false);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, -0.25),
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
      child: show == true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "O adiantamento sera creditado em sua Conta Corrente selecionada abaixo",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColorLight,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      "Adiantamento liberado",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Currency.format(saleController.maxQuickMoney),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
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
                        saleController.showSelectedAccountQuickMoney ??
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
                        if (saleController.selectedAccountQuickMoney == null) {
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
                              saleController.selectedAccountQuickMoney;
                          showOptionsDialog(
                            context,
                            title: "Selecione o banco e conta",
                            actions: [
                              TextButton(
                                onPressed: () {
                                  saleController
                                      .setSelectedAccountQuickMoney(oldValue);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancelar',
                                  style: AppFonts.textButton,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Selecionar',
                                  style: AppFonts.textButton,
                                ),
                              )
                            ],
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ChangeNotifierProvider.value(
                                value: saleController,
                                child: Consumer<SalePageController>(
                                    builder: (context, saleController, _) {
                                  return Column(
                                    children: [
                                      ...saleController.bankAccounts
                                          .asMap()
                                          .entries
                                          .map((item) {
                                        var splicedId =
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
                                                    style: AppFonts.text,
                                                  ),
                                                ),
                                                Radio(
                                                  value: item.value,
                                                  groupValue: saleController
                                                      .selectedAccountQuickMoney,
                                                  onChanged: saleController
                                                      .setSelectedAccountQuickMoney,
                                                )
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
                TextFormField(
                  focusNode: saleController.quickMoneyInputControllerNode,
                  controller: saleController.quickMoneyInputController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [saleController.currencyFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe o valor do adiantamento";
                    }

                    final doubleValue = saleController.currencyFormatter
                        .getUnformattedValue()
                        .toDouble();

                    var formattedMaxQuickMoney =
                        saleController.maxQuickMoney.toStringAsFixed(2);

                    return maxNumberValidator(
                      doubleValue.toString(),
                      double.parse(formattedMaxQuickMoney),
                      useCurrencyFormatter: true,
                    );
                  },
                  style: GoogleFonts.montserrat(
                    color: AppColors.textColorLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "Quanto você deseja de adiantamento?",
                    hintStyle: GoogleFonts.montserrat(
                      color: AppColors.textColorLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            )
          : Container(),
    );
  }

  Widget quickMoneyControl(BuildContext context) {
    var saleController =
        Provider.of<SalePageController>(context, listen: false);

    return Row(
      children: [
        buttonSelector(
          disabled: !saleController.isAllowedToUseQuickMoney,
          isSelected: saleController.isQuickMoney == true,
          label: "Sim",
          isRight: false,
          onTap: () {
            saleController.setQuickMoney(true);
          },
        ),
        buttonSelector(
          disabled: false,
          isSelected: saleController.isQuickMoney == false,
          label: "Não",
          isRight: true,
          onTap: () {
            saleController.setQuickMoney(false);
            saleController.setSelectedAccountQuickMoney(null);
            saleController.quickMoneyInputController.clear();
          },
        ),
      ],
    );
  }

  Widget buttonSelector({
    required bool disabled,
    required bool isSelected,
    required String label,
    required bool isRight,
    required void Function() onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: disabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: disabled
                ? Colors.grey.withValues(alpha: 0.05)
                : (isSelected ? AppColors.primaryLight : Colors.transparent),
            border: Border(
              left: !isRight
                  ? const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1,
                    )
                  : BorderSide.none,
              right: const BorderSide(
                color: AppColors.primaryColor,
                width: 1,
              ),
              top: const BorderSide(
                color: AppColors.primaryColor,
                width: 1,
              ),
              bottom: const BorderSide(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(!isRight ? 10 : 0),
              topRight: Radius.circular(isRight ? 10 : 0),
              bottomLeft: Radius.circular(!isRight ? 10 : 0),
              bottomRight: Radius.circular(isRight ? 10 : 0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(17.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected) ...[
                  const Icon(
                    Icons.check,
                    color: AppColors.textColor,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: disabled
                        ? Colors.grey
                        : (isSelected
                            ? AppColors.textColor
                            : AppColors.textColorLight),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _warnings(BuildContext context) {
    var saleController =
        Provider.of<SalePageController>(context, listen: false);

    return Column(
      children: [
        if (saleController.isQuickMoney == true) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.error_outline_outlined,
                color: AppColors.primaryColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Estou ciente que apenas o adiantamento feito até às 14:00hs será depositado no mesmo dia; e Concordo com a cobrança de encargos de 1,95% ao mês incidentes sobre o valor do adiantamento.",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColorLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.error_outline_outlined,
              color: AppColors.primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "* Autorizo a COCATREL a proceder o desconto do(s) eventual(is) débito(s) vencido(s) de minha responsabilidade",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.error_outline_outlined,
              color: AppColors.primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "* Solicito que a COCATREL promova a comercialização do(s) lote(s) de café acima descrito(s)",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorLight,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _footerActions(BuildContext context) {
    var saleController =
        Provider.of<SalePageController>(context, listen: false);

    return Row(
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
            if (controller.formKey.currentState!.validate()) {
              _showDialog(context);
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
    );
  }

  void _showDialog(BuildContext context) {
    var saleController =
        Provider.of<SalePageController>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return ChangeNotifierProvider.value(
          value: dialogController,
          builder: (context, child) {
            return Consumer<DialogController>(
              builder: (context, value, child) {
                return BasicAlertDialog(
                  title: "Finalizar autorização",
                  content: Column(
                    children: [
                      Text(
                        "O valor da venda poderá sofrer oscilação de acordo com o MERCADO DO DIA da venda do seu café.",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "As autorizações de venda realizadas após as 17h serão contabilizadas para o mercado do dia seguinte.",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorLight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: dialogController.isAgree,
                            activeColor: AppColors.primaryColor,
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: dialogController.hasError
                                  ? AppColors.danger
                                  : AppColors.textColorLight,
                              width: 2,
                            ),
                            onChanged: (value) {
                              dialogController.setError(false);
                              dialogController.toggleAgree();
                            },
                            isError: dialogController.hasError,
                          ),
                          const Text(
                            "Entendi e estou de acordo.",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          "Voltar",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.buttonTextLight,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: !dialogController.isLoading
                          ? () async {
                              if (dialogController.isAgree) {
                                dialogController.setLoading(true);
                                var data =
                                    await saleController.completeSale(context);

                                if (context.mounted && data != null) {
                                  Navigator.pop(context);

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    AppRoutes.pdfPage,
                                    arguments: {
                                      'pdfData': data,
                                      'title': 'Autorização de venda',
                                    },
                                    (route) => false,
                                  );
                                } else if (data == null && context.mounted) {
                                  Navigator.pop(context);
                                }
                              } else {
                                dialogController.setError(true);
                              }
                            }
                          : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (dialogController.isLoading) ...[
                            const SizedBox(
                              width: 67,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.buttonTextLight,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 67,
                              height: 24,
                            ),
                          ] else ...[
                            Text(
                              "Autorizar venda",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.buttonTextLight,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.price_check_rounded,
                              color: AppColors.buttonTextLight,
                            )
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
