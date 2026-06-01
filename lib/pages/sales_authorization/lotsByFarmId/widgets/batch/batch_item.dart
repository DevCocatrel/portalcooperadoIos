import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/dialog/basic_dialog.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/formatters/comma_formatter.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/core/utils/hex_to_color.dart';
import 'package:cocatrel/core/validators/max_number_validator.dart';
import 'package:cocatrel/models/authorization_sale_batches_model.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/list_lots_by_farm_id_controller.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/widgets/batch/batch_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BatchItem extends StatefulWidget {
  final AuthorizationSaleBatchesModel batch;

  const BatchItem({
    super.key,
    required this.batch,
  });

  @override
  State createState() => _BatchItemState();
}

class _BatchItemState extends State<BatchItem> {
  bool _isExpanded = false;
  late AuthorizationSaleBatchesModel batch = widget.batch;
  final controller = BatchItemController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: DefaultCardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  batch.batch,
                  style: GoogleFonts.montserrat(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorTransform.hexToColor(
                      batch.backgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  batch.standardClassification,
                  style: GoogleFonts.montserrat(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _textItem(
              label: "Padrão",
              value: batch.standardClassification,
              hasDivider: true,
            ),
            _textItem(
              label: "Data de entrada",
              value: normalizeDate(batch.entryDate),
              hasDivider: true,
            ),
            _textItem(
              label: "Bebida",
              value: batch.drinkClassification,
              hasDivider: true,
            ),
            _textItem(
              label: "Safra",
              value: batch.harvestClassification,
              hasDivider: true,
            ),
            _textItem(
              label: "Personalizado",
              value: batch.customClassification,
              hasDivider: true,
            ),
            _textItem(
              label: "% Quebra",
              value: batch.classificationPerBreak.toString(),
              hasDivider: true,
            ),
            _textItem(
              label: "Fava",
              value: batch.beanClassification.trim(),
              hasDivider: true,
            ),
            _textItem(
              label: "% Seca",
              value: batch.dryClassification,
              hasDivider: true,
            ),
            _textItem(
              label: "Pr. Unitario Liquido",
              value: Currency.format(batch.netUnitPrice),
              hasDivider: true,
            ),
            ExpansionTile(
              tilePadding: const EdgeInsets.all(0),
              dense: true,
              collapsedShape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              childrenPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              iconColor: AppColors.primaryColor,
              collapsedIconColor: AppColors.primaryColor,
              maintainState: true,
              minTileHeight: 29,
              enableFeedback: false,
              title: Text(
                "Ver mais detalhes",
                style: GoogleFonts.montserrat(
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Saldos",
                      style: GoogleFonts.montserrat(
                        color: AppColors.textColorLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                _textItem(
                  label: "Sacas entrada",
                  value: batch.balanceEntryBags.toString(),
                  hasDivider: true,
                ),
                _textItem(
                  label: "Saldo Sacas",
                  value: batch.balanceBags.toString(),
                  hasDivider: true,
                ),
                _textItem(
                  label: "Sacas bloqueadas",
                  value: batch.blockedBalanceBags.toString(),
                  hasDivider: true,
                ),
                _textItem(
                  label: "Sacas autorizadas",
                  value: batch.authorizedBags.toString(),
                  hasDivider: true,
                ),
                _textItem(
                  label: "Sacas disponíveis",
                  value: batch.availableBags.toString(),
                  hasDivider: true,
                ),
                _textItem(
                  label: "Pr. Unitario Liquido",
                  value: Currency.format(batch.netUnitPrice),
                  hasDivider: true,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: Alignment.topLeft,
              child: _isExpanded ? _formBatch() : Container(),
            ),
            const SizedBox(height: 16),
            if (batch.availableBags == 0) ...[
              _warning(
                message: "Não há sacas disponíveis para venda.",
                isDanger: true,
              ),
            ],
            if (batch.availableBags > 0) ...[
              ElevatedButton(
                onPressed: () {
                  if (!_isExpanded) {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });

                    return;
                  }

                  controller.addBatchItemToCard(context, batch);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: AppColors.buttonTextLight,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      !_isExpanded
                          ? "Adicionar à venda"
                          : "Adicionar ao carrinho",
                      style: GoogleFonts.montserrat(
                        color: AppColors.buttonTextLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _formBatch() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            "Sacas a autorizar",
            style: GoogleFonts.montserrat(
              color: AppColors.textColorLight,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Qual preço será praticado na saca de café?",
            style: GoogleFonts.montserrat(
              color: AppColors.textColorLight,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              DropdownButtonFormField(
                hint: Text(
                  controller.coffeeModality == null
                      ? "Selecione o tipo de preço"
                      : convertModalityToString(controller.coffeeModality!),
                  style: const TextStyle(
                    color: AppColors.textColorLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                  color: AppColors.textColor,
                ),
                initialValue: controller.coffeeModality == null
                    ? null
                    : convertModalityToString(controller.coffeeModality!),
                isDense: true,
                dropdownColor: AppColors.backgroundColor,
                style: GoogleFonts.montserrat(
                  color: AppColors.textColorLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                validator: (value) {
                  if (value == null) {
                    return "Selecione o tipo de preço";
                  }

                  return null;
                },
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
                onChanged: (value) {},
              ),
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    selectMarketFunction(String? value) {
                      controller.clearInputs();

                      controller.setCoffeeModality(CoffeeModality.market);
                    }

                    selectPrefixFunction(String? value) {
                      Navigator.of(context).pop();
                      controller.clearInputs();
                      _showDialogPrefixConfirmation(context);
                    }

                    void Function(String?) cancelFunction = (String? value) {
                      controller.clearInputs();

                      controller.setCoffeeModality(null);
                      Navigator.of(context).pop();
                    };

                    if (controller.coffeeModality == CoffeeModality.market) {
                      cancelFunction = (String? value) {
                        selectMarketFunction(value);
                        Navigator.of(context).pop();
                      };
                    } else if (controller.coffeeModality ==
                        CoffeeModality.prefix) {
                      cancelFunction = (String? value) {
                        controller.setCoffeeModality(CoffeeModality.prefix);

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      };
                    }

                    showOptionsDialog(
                      context,
                      title: 'Selecione o tipo de preço',
                      actions: [
                        TextButton(
                          onPressed: () {
                            cancelFunction('');
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
                          value: controller,
                          child: Consumer<BatchItemController>(
                              builder: (context, controller, _) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Mercado do dia'),
                                    ),
                                    Radio(
                                      value: 'Mercado do dia',
                                      onChanged: selectMarketFunction,
                                      groupValue:
                                          controller.coffeeModality == null
                                              ? null
                                              : convertModalityToString(
                                                  controller.coffeeModality!),
                                    ),
                                  ],
                                ),
                                const DividerCardWidget(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Preço prefixado'),
                                    ),
                                    Radio(
                                      value: 'Preço prefixado',
                                      onChanged: selectPrefixFunction,
                                      groupValue:
                                          controller.coffeeModality == null
                                              ? null
                                              : convertModalityToString(
                                                  controller.coffeeModality!),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          if (controller.coffeeModality == CoffeeModality.prefix) ...[
            Text(
              "Qual o valor da saca de café?",
              style: GoogleFonts.montserrat(
                color: AppColors.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: controller.priceInputControllerNode,
              controller: controller.priceInputController,
              keyboardType: TextInputType.number,
              onEditingComplete: () {
                controller.bagsInputControllerNode.requestFocus();
              },
              inputFormatters: [controller.currencyFormatter],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Informe o preço da saca";
                }

                return null;
              },
              style: GoogleFonts.montserrat(
                color: AppColors.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: "Preço por saca",
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
            _warning(
              message:
                  "ATENÇÃO ao digitar o preço desejado, pois seu café sera vendido somente quando alcançar o preço que você informou.",
            ),
            const SizedBox(height: 16),
          ],
          Text(
            "Qual quantidade de sacas deseja autorizar para venda?",
            style: GoogleFonts.montserrat(
              color: AppColors.textColorLight,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.bagsInputController,
                  focusNode: controller.bagsInputControllerNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    return maxNumberValidator(
                        value, batch.availableBags - batch.blockedBalanceBags);
                  },
                  style: GoogleFonts.montserrat(
                    color: AppColors.textColorLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (value) {
                    if (value.contains(',')) {
                      controller.bagsInputController.text =
                          value.replaceAll(',', '.');
                      return;
                    }
                    var valueFormatted = value.replaceAll(",", ".");
                    var valueCalculated = calculateWeightWithBags(
                      double.tryParse(valueFormatted) ?? 0,
                    );

                    controller.weightInputController.text =
                        valueCalculated == 0 ? "" : valueCalculated.toString();
                  },
                  inputFormatters: [
                    CommaFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: "Qdt. de sacas",
                    errorStyle: GoogleFonts.montserrat(
                      color: AppColors.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
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
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  focusNode: controller.weightInputControllerNode,
                  controller: controller.weightInputController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    return maxNumberValidator(
                      value,
                      calculateWeightWithBags(
                        batch.availableBags - batch.blockedBalanceBags,
                      ),
                    );
                  },
                  onChanged: (value) {
                    if (value.contains(',')) {
                      controller.weightInputController.text =
                          value.replaceAll(',', '.');
                      return;
                    }
                    var valueFormatted = value.replaceAll(",", ".");
                    var valueCalculated = calculateBagsWithWeight(
                      double.tryParse(valueFormatted) ?? 0,
                    );

                    controller.bagsInputController.text =
                        valueCalculated == 0 ? "" : valueCalculated.toString();
                  },
                  inputFormatters: [
                    CommaFormatter(),
                  ],
                  style: GoogleFonts.montserrat(
                    color: AppColors.textColorLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "Peso em kg",
                    errorStyle: GoogleFonts.montserrat(
                      color: AppColors.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
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
              ),
            ],
          ),
          const SizedBox(height: 16),
          _warning(
            message:
                "Este valor poderá sofrer oscilação de acordo com o MERCADO DO DIA da venda do seu café.",
          ),
        ],
      ),
    );
  }

  Widget _warning({
    bool isDanger = false,
    required String message,
  }) {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          color: isDanger ? AppColors.danger : AppColors.primaryColor,
          size: 22,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.montserrat(
              color: AppColors.textColorLight,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _textItem({
    required String label,
    required String value,
    bool hasDivider = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: AppColors.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.montserrat(
                color: AppColors.textColorLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        if (hasDivider)
          const Divider(
            color: AppColors.borderColor,
            height: 16,
          ),
      ],
    );
  }

  void _showDialogPrefixConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return BasicAlertDialog(
          title: "Confirmação de preço prefixado",
          content: Column(
            children: [
              Text(
                "ATENÇÃO - Prezado cooperado(a), você selecionou a modalidade de venda com preço tabelado, ou seja, seu café será vendido apenas na data em que o preço de venda bruto escolhido seja alcançado pelo preço do mercado do dia.",
                style: GoogleFonts.montserrat(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
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
              onPressed: () async {
                controller.setCoffeeModality(CoffeeModality.prefix);

                await Future.delayed(const Duration(milliseconds: 500));

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Selecionar",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.buttonTextLight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double calculateBagsWithWeight(double weight) {
    return double.parse((weight / 60).toStringAsFixed(2));
  }

  double calculateWeightWithBags(double bags) {
    return double.parse((bags * 60).toStringAsFixed(8));
  }
}
