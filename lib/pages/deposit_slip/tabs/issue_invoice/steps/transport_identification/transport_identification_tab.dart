import 'dart:async';

import 'package:cnpj_cpf_formatter_nullsafety/cnpj_cpf_formatter_nullsafety.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/title/title_with_icon_card_widget.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/styles/app_input_decoration.dart';
import 'package:cocatrel/core/utils/brazilian_ufs.dart';
import 'package:cocatrel/core/utils/input_masks.dart';
import 'package:cocatrel/core/utils/input_formatters.dart';
import 'package:cocatrel/core/utils/validators.dart';
import 'package:cocatrel/models/coffee_entry_model.dart';
import 'package:cocatrel/pages/deposit_slip/common/binary_selection_widget.dart';
import 'package:cocatrel/pages/deposit_slip/common/steps_widget.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/issue_invoice_index_steps_controller.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/transport_identification/transport_identification_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransportIdentificationTab extends StatelessWidget {
  TransportIdentificationTab(DepositSlip depositSlip, {super.key}) {
    transportIdentificationController =
        TransportIdentificationController(depositSlip);
  }

  late final TransportIdentificationController
      transportIdentificationController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: transportIdentificationController,
      child: Consumer<TransportIdentificationController>(
        builder: (context, controller, _) {
          return Form(
            key: controller.transportIdentificationFormKey,
            child: ListView(
              children: [
                const StepsWidget(2, 'Identificação de transporte'),
                DefaultCardWidget(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleWithIconCardWidget(
                        title: 'Transporte',
                        icon: Icons.local_shipping_outlined,
                      ),
                      BinarySelectionWidget(
                          title:
                              'Você quer escolher ou informar o meio transporte?',
                          option1: 'Escolher',
                          option2: 'Informar',
                          optionSelected:
                              controller.depositSlip.meansTransportation
                                  ? 'Escolher'
                                  : 'Informar',
                          onTap1: () {
                            controller.changeSelectMeansTransport(true);
                          },
                          onTap2: () {
                            controller.changeSelectMeansTransport(false);
                          }),
                      if (!controller.depositSlip.meansTransportation)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Dados do transportador',
                              style: AppFonts.text,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: TextFormField(
                                controller:
                                    controller.carrierNameTextController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome/Razão Social',
                                ),
                                validator: nameValidator,
                              ),
                            ),
                            TextFormField(
                              controller:
                                  controller.documentNumberTextController,
                              decoration: const InputDecoration(
                                labelText: 'CNPJ / CPF',
                              ),
                              inputFormatters: [
                                CnpjCpfFormatter(
                                  eDocumentType: EDocumentType.BOTH,
                                )
                              ],
                              validator: (value) {
                                final validator = documentValidator(value);
                                final validator2 = cnpjValidator(value);
                                if (validator == null) {
                                  return null;
                                } else if (validator2 == null) {
                                  return null;
                                }
                                if ((value ?? '').length > 14) {
                                  return validator;
                                }
                                return validator2;
                              },
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      BinarySelectionWidget(
                          title: 'Qual o tipo do veículo?',
                          option1: 'Licenciado',
                          option2: 'Trator',
                          optionSelected: controller.depositSlip.vehicleType ==
                                  VehicleType.licensed
                              ? 'Licenciado'
                              : 'Trator',
                          onTap1: () {
                            controller.changeVehicleType(VehicleType.licensed);
                          },
                          onTap2: () {
                            controller.changeVehicleType(VehicleType.tractor);
                          }),
                      dropdownTractorBrandWidget(context, controller),
                      Consumer<IssueInvoiceIndexController>(
                          builder: (context, controller, _) {
                        return carrierDropDownWidget(context, controller);
                      }),
                      ufDropdownWidget(controller, context),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.plateTextController,
                        enabled: controller.enablePlate,
                        maxLength: controller.enablePlate ? 8 : null,
                        decoration: const InputDecoration(
                          labelText: 'Informe o número da placa',
                        ),
                        inputFormatters: controller.enablePlate
                            ? [
                                UpperCaseTextInputFormatter(),
                                PlateInputFormatter(),
                              ]
                            : [],
                        validator:
                            controller.enablePlate ? plateValidator : null,
                      ),
                      if (controller.depositSlip.vehicleType ==
                          VehicleType.tractor)
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: controller.driverTextController,
                              decoration: const InputDecoration(
                                labelText: 'Informe o nome do motorista',
                              ),
                              validator: nameValidator,
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              context
                                  .read<IssueInvoiceIndexController>()
                                  .tabController
                                  .animateTo(0);
                            },
                            child: Text(
                              'Voltar',
                              style: AppFonts.textButton,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.validateForm()) {
                                context
                                    .read<IssueInvoiceIndexController>()
                                    .tabController
                                    .animateTo(2);
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Próximo',
                                  style: AppFonts.textButton,
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_outlined,
                                  color: AppColors.buttonTextLight,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget dropdownTractorBrandWidget(
      BuildContext context, TransportIdentificationController controller) {
    if (controller.depositSlip.vehicleType == VehicleType.tractor) {
      final indexController = context.read<IssueInvoiceIndexController>();
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: InkWell(
          onTap: () {
            final oldValue = controller.depositSlip.tractorBrand;
            showOptionsDialog(
              context,
              title: 'Selecione o modelo do trator',
              content: SizedBox(
                width: double.maxFinite,
                child: ChangeNotifierProvider.value(
                  value: controller,
                  child: Consumer<TransportIdentificationController>(
                      builder: (context, _, __) {
                    return Column(
                      children: indexController.tractorList.isRight
                          ? [
                              ...indexController.tractorList.right
                                  .asMap()
                                  .entries
                                  .map(
                                    (item) => Container(
                                      decoration: BoxDecoration(
                                        border: item.key == 0
                                            ? null
                                            : const Border(
                                                top: BorderSide(
                                                  color: AppColors.borderColor,
                                                ),
                                              ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.value,
                                              style: AppFonts.text,
                                            ),
                                          ),
                                          Radio(
                                            value: item.value,
                                            groupValue: controller
                                                .depositSlip.tractorBrand,
                                            onChanged:
                                                controller.setCurrentTractor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            ]
                          : [],
                    );
                  }),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.setCurrentTractor(oldValue);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: AppFonts.textButton,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Selecionar',
                    style: AppFonts.textButton,
                  ),
                ),
              ],
            );
          },
          child: DropdownButtonFormField<String>(
            initialValue: controller.depositSlip.uf,
            validator: (_) {
              if (controller.depositSlip.tractorBrand != null) return null;
              return 'Selecione o modelo do trator';
            },
            decoration: InputDecoration(
              labelText: controller.depositSlip.tractorBrand ??
                  'Selecione o modelo do trator',
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.textColorLight,
            ),
            onChanged: (_) {},
            items: const [],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget ufDropdownWidget(
      TransportIdentificationController controller, BuildContext context) {
    if (controller.depositSlip.vehicleType == VehicleType.licensed) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: InkWell(
          child: Stack(
            children: [
              DropdownButtonFormField<String>(
                initialValue: controller.depositSlip.uf,
                validator: (_) {
                  if ((controller.depositSlip.uf ?? '').isEmpty) {
                    return 'Selecione um UF da placa';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: (controller.depositSlip.uf?.isEmpty ?? true)
                      ? 'Informe o UF da placa'
                      : controller.depositSlip.uf,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textColorLight,
                ),
                onChanged: (_) {},
                items: controller.depositSlip.carrier?.carrierUf != null
                    ? null
                    : const [],
              ),
              if ((controller.depositSlip.carrier?.carrierUf ?? '').isNotEmpty)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withValues(alpha: .5),
                  ),
                ),
            ],
          ),
          onTap: () {
            if (controller.depositSlip.carrier?.carrierUf != null) {
              return;
            }
            final oldValue = controller.depositSlip.uf;
            showOptionsDialog(
              context,
              title: 'Informe o UF da placa',
              content: SizedBox(
                width: double.maxFinite,
                child: ChangeNotifierProvider.value(
                  value: controller,
                  child: Consumer<TransportIdentificationController>(
                    builder: (_, controller, __) => Column(
                      children: brazilianUfs
                          .asMap()
                          .entries
                          .map(
                            (uf) => Container(
                              decoration: BoxDecoration(
                                border: uf.key == 0
                                    ? null
                                    : const Border(
                                        top: BorderSide(
                                          color: AppColors.borderColor,
                                        ),
                                      ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(uf.value),
                                  Radio(
                                    value: uf.value,
                                    groupValue: controller.depositSlip.uf ?? '',
                                    onChanged: (_) {
                                      controller.changeCurrentUf(uf.value);
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.changeCurrentUf(oldValue);
                  },
                  child: Text(
                    'Cancelar',
                    style: AppFonts.textButton,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Selecionar',
                    style: AppFonts.textButton,
                  ),
                )
              ],
            );
          },
        ),
      );
    }
    return const SizedBox();
  }

  Widget carrierDropDownWidget(
    BuildContext context,
    IssueInvoiceIndexController controller,
  ) {
    if (controller.depositSlip.meansTransportation &&
        controller.depositSlip.vehicleType == VehicleType.licensed) {
      return Container(
        padding: const EdgeInsets.only(top: 16),
        child: Stack(
          children: [
            DropdownSearch<CarrierModel>(
              validator: (_) {
                if (controller.depositSlip.carrier == null) {
                  return 'Selecione uma transportadora';
                }
                return null;
              },
              dropdownBuilder: (context, data) {
                return Text(
                  data?.carrierName ?? '',
                  maxLines: 1,
                  style: AppFonts.text,
                );
              },
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  iconColor: AppColors.textColorLight,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: 'Selecione a transportadora',
                  hintStyle: AppFonts.text,
                  border: border,
                  focusedBorder: focusedBorder,
                  enabledBorder: border,
                ),
              ),
              popupProps: PopupProps.dialog(
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    labelText: 'Nome da transportadora',
                    suffixIcon: const Icon(Icons.search_outlined),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Selecione a transportadora',
                    style: AppFonts.title,
                  ),
                ),
                dialogProps: DialogProps(
                  contentPadding: EdgeInsets.zero,
                  actionsPadding: const EdgeInsets.all(16),
                  actions: [
                    Builder(
                      builder: (context) {
                        return TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancelar',
                            style: AppFonts.textButton,
                          ),
                        );
                      },
                    ),
                  ],
                  backgroundColor: AppColors.backgroundColor,
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                ),
                fit: FlexFit.loose,
                itemBuilder: (context, data, isDisabled, selected) {
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: AppColors.borderColor, width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 4,
                      bottom: 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.carrierName ?? '',
                            style: AppFonts.text,
                          ),
                        ),
                        Radio(
                          value: data,
                          groupValue: controller.depositSlip.carrier,
                          onChanged: (_) {},
                        )
                      ],
                    ),
                  );
                },
                showSearchBox: true,
                emptyBuilder: (context, data) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Nenhuma transportadora encontrada com esse nome",
                      style: AppFonts.text,
                    ),
                  ),
                ),
              ),
              compareFn: (a, b) {
                return a.carrierCode == b.carrierCode;
              },
              itemAsString: (data) => data.carrierName ?? '',
              onChanged: context
                  .read<TransportIdentificationController>()
                  .setCurrentCarrier,
              selectedItem: controller.depositSlip.carrier,
              items: (_, __) {
                final list = controller.coffeeEntry.right.carriers ?? [];
                return Future.value(list);
              },
            ),
            if (controller.loadingCoffeeEntry)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: .5),
                  child: const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              )
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
