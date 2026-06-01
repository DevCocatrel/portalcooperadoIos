import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/title/title_with_icon_card_widget.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/validators.dart';
import 'package:cocatrel/pages/deposit_slip/common/steps_widget.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/delivery_information/delivery_information_controller.dart';
import 'package:cocatrel/pages/deposit_slip/tabs/issue_invoice/steps/issue_invoice_index_steps_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryInformationTab extends StatelessWidget {
  DeliveryInformationTab(DepositSlip depositSlip, {super.key}) {
    deliveryInformationController = DeliveryInformationController(depositSlip);
  }

  late final DeliveryInformationController deliveryInformationController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: deliveryInformationController,
      child: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const StepsWidget(4, 'Informações de entrega'),
              DefaultCardWidget(
                child: Form(
                  key: deliveryInformationController.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleWithIconCardWidget(
                        title: 'Entrega',
                        icon: Icons.location_on_outlined,
                      ),
                      Text('Local de entrega', style: AppFonts.text),
                      const SizedBox(height: 16),
                      locationDropDownDeliveryWidget(context),
                      const SizedBox(height: 16),
                      Text('Embalagem de entrega', style: AppFonts.text),
                      const SizedBox(height: 16),
                      packagingDropDownWidget(context),
                      const SizedBox(height: 16),
                      Text(
                        'Email para recebimento da NFE',
                        style: AppFonts.text,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller:
                            deliveryInformationController.emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Informe o email',
                        ),
                        validator: emailValidator,
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
                                  .animateTo(2);
                            },
                            child: Text(
                              'Voltar',
                              style: AppFonts.textButton,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (deliveryInformationController.validate()) {
                                IssueInvoiceIndexController.of(context)
                                    .tabController
                                    .animateTo(4);
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Próximo',
                                  style: AppFonts.textButton,
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_outlined)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  InkWell locationDropDownDeliveryWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        final indexController = context.read<IssueInvoiceIndexController>();
        final oldValue = indexController.depositSlip.warehouse;
        showOptionsDialog(
          context,
          title: 'Selecione o local de entrega',
          content: ChangeNotifierProvider.value(
            value: deliveryInformationController,
            child: Consumer<DeliveryInformationController>(
                builder: (context, controller, _) {
              return Column(
                children: [
                  ...(indexController.coffeeEntry.right.warehouses ?? [])
                      .asMap()
                      .entries
                      .map(
                        (item) => Container(
                          width: double.maxFinite,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.value.warehouseName ?? ''),
                              Radio(
                                value: item.value,
                                groupValue: controller.depositSlip.warehouse,
                                onChanged: (value) {
                                  controller.changeWarehouse(value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deliveryInformationController.changeWarehouse(oldValue);
              },
              child: Text(
                'Cancelar',
                style: AppFonts.textButton,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Selecionar',
                style: AppFonts.textButton,
              ),
            ),
          ],
        );
      },
      child: Consumer<DeliveryInformationController>(
          builder: (context, controller, _) {
        return DropdownButtonFormField(
          items: const [],
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textColor,
          ),
          decoration: InputDecoration(
              labelText: controller.depositSlip.warehouse?.warehouseName ??
                  'Selecione o local'),
          onChanged: (_) {},
          validator: (_) {
            if (controller.depositSlip.warehouse == null) {
              return 'Selecione um local';
            }
            return null;
          },
        );
      }),
    );
  }

  InkWell packagingDropDownWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        final indexController = context.read<IssueInvoiceIndexController>();
        final oldValue = indexController.depositSlip.packaging;
        showOptionsDialog(
          context,
          title: 'Selecione a embalagem',
          content: ChangeNotifierProvider.value(
            value: deliveryInformationController,
            child: Consumer<DeliveryInformationController>(
                builder: (context, controller, _) {
              return Column(
                children: [
                  ...(indexController.coffeeEntry.right.packaging ?? [])
                      .asMap()
                      .entries
                      .map(
                        (item) => Container(
                          width: double.maxFinite,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.value.packagingName ?? ''),
                              Radio(
                                value: item.value,
                                groupValue: controller.depositSlip.packaging,
                                onChanged: (value) {
                                  controller.changePackaging(value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deliveryInformationController.changePackaging(oldValue);
              },
              child: Text(
                'Cancelar',
                style: AppFonts.textButton,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Selecionar',
                style: AppFonts.textButton,
              ),
            ),
          ],
        );
      },
      child: Consumer<DeliveryInformationController>(
          builder: (context, controller, _) {
        return DropdownButtonFormField(
          items: const [],
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textColor,
          ),
          decoration: InputDecoration(
              labelText: controller.depositSlip.packaging?.packagingName ??
                  'Selecione a embalagem'),
          onChanged: (_) {},
          validator: (_) {
            if (controller.depositSlip.packaging == null) {
              return 'Selecione uma embalagem';
            }
            return null;
          },
        );
      }),
    );
  }
}
