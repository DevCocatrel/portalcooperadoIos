import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';

import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';

import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';

import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';

import 'package:cocatrel/common/widgets/divider/divider_widget.dart';

import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';

import 'package:cocatrel/core/app/app_assets.dart';

import 'package:cocatrel/core/app/app_colors.dart';

import 'package:cocatrel/core/styles/app_fonts.dart';

import 'package:cocatrel/pages/coffee_movement/coffee_movement_filter_controller.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';



class CoffeeMovementFilterPage extends StatelessWidget {

  CoffeeMovementFilterPage({super.key});



  final coffeeMovementController = CoffeeMovementFilterController();



  @override

  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(

      value: coffeeMovementController,

      child: DefaultScaffoldWidget(

        appBar: const ProfileAppBar(

          title: 'Movimentação do café',

        ),

        drawer: const BasicMenuDrawer(),

        body: Container(

          margin: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 32),

              const Text('Extrato de Movimentação'),

              const SizedBox(height: 16),

              DefaultCardWidget(

                child: Form(

                  key: coffeeMovementController.formKey,

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const Row(

                        children: [

                          Icon(

                            Icons.article_outlined,

                            color: AppColors.primaryDark,

                          ),

                          SizedBox(width: 8),

                          Expanded(

                            child: Text(

                              'Selecionar um período',

                              style: TextStyle(

                                color: AppColors.primaryDark,

                              ),

                            ),

                          ),

                        ],

                      ),

                      const SizedBox(height: 16),

                      Consumer<CoffeeMovementFilterController>(

                        builder: (context, controller, _) {

                          return Stack(

                            children: [

                              DropdownButtonFormField(

                                itemHeight: null,

                                isExpanded: true,

                                icon: const Icon(

                                  Icons.arrow_drop_down,

                                  size: 24,

                                  color: AppColors.textColor,

                                ),

                                hint: FittedBox(

                                  alignment: Alignment.centerLeft,

                                  fit: BoxFit.scaleDown,

                                  child: Text(controller.hintFarmOptions),

                                ),

                                items: const [],

                                validator: (value) {

                                  if (controller.currentOptionFarmIndex ==

                                      null) {

                                    return 'Selecione um item';

                                  }

                                  return null;

                                },

                                onChanged: (_) {},

                              ),

                              Positioned.fill(

                                child: InkWell(

                                  onTap: () {

                                    showFarmOptionsDialog(context,

                                        controller.currentOptionFarmIndex);

                                  },

                                ),

                              ),

                            ],

                          );

                        },

                      ),

                      const SizedBox(height: 16),

                      Consumer<CoffeeMovementFilterController>(

                        builder: (context, controller, _) {

                          return Stack(

                            children: [

                              DropdownButtonFormField(

                                icon: const Icon(

                                  Icons.arrow_drop_down,

                                  size: 24,

                                  color: AppColors.textColor,

                                ),

                                hint: Text(controller.hintMovementTypeOptions),

                                items: const [],

                                validator: (value) {

                                  if (controller

                                          .currentOptionMovementTypeIndex ==

                                      null) {

                                    return 'Selecione um item';

                                  }

                                  return null;

                                },

                                onChanged: (_) {},

                              ),

                              Positioned.fill(

                                child: InkWell(

                                  onTap: () {

                                    showMovementTypeOptionsDialog(

                                        context,

                                        controller

                                            .currentOptionMovementTypeIndex);

                                  },

                                ),

                              ),

                            ],

                          );

                        },

                      ),

                      const SizedBox(height: 16),

                      Consumer<CoffeeMovementFilterController>(

                          builder: (context, controller, _) {

                        return Row(

                          children: [

                            Expanded(

                              child: Stack(

                                children: [

                                  TextFormField(

                                    controller: TextEditingController(

                                        text: controller.statDateFormatted),

                                    decoration: const InputDecoration(

                                      labelText: 'Data Inicial',

                                      suffixIcon:

                                          Icon(Icons.calendar_month_outlined),

                                    ),

                                    validator: (value) {

                                      if ((value ?? '').isEmpty) {

                                        return 'Escolha a data inicial';

                                      }

                                      return null;

                                    },

                                  ),

                                  Positioned.fill(

                                    child: InkWell(

                                      onTap: () async {

                                        final date = await showDatePicker(

                                          context: context,

                                          initialDate: controller.startTime,

                                          cancelText: 'Cancelar',

                                          confirmText: 'Ok',

                                          firstDate: DateTime(1900),

                                          lastDate: DateTime.now(),

                                        );

                                        if (date != null) {

                                          controller.setStartDate(date);

                                        }

                                      },

                                    ),

                                  ),

                                ],

                              ),

                            ),

                            const SizedBox(

                                width: 16.0), // Add spacing between the fields



                            // Second TextFormField

                            Expanded(

                              child: Stack(

                                children: [

                                  TextFormField(

                                    controller: TextEditingController(

                                        text: controller.endDateFormatted),

                                    decoration: const InputDecoration(

                                      labelText: 'Data Final',

                                      suffixIcon:

                                          Icon(Icons.calendar_month_outlined),

                                    ),

                                    validator: (value) {

                                      if ((value ?? '').isEmpty) {

                                        return 'Escolha a data final';

                                      }

                                      return null;

                                    },

                                  ),

                                  Positioned.fill(

                                    child: InkWell(

                                      onTap: () async {

                                        final date = await showDatePicker(

                                          context: context,

                                          initialDate: controller.endDate,

                                          firstDate: DateTime(1900),

                                          lastDate: DateTime.now(),

                                          cancelText: 'Cancelar',

                                          confirmText: 'Ok',

                                        );

                                        if (date != null) {

                                          controller.setEndDate(date);

                                        }

                                      },

                                    ),

                                  ),

                                ],

                              ),

                            ),

                          ],

                        );

                      }),

                      const SizedBox(height: 16),

                      ElevatedButton(
  onPressed: () {
    if (coffeeMovementController.formKey.currentState!.validate()) {
      // Abre o diálogo usando o padrão do seu projeto (showOptionsDialog)
      showOptionsDialog(
        context,
        title: 'Comunicado aos Cooperados',
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informamos que o relatório Extrato do Cooperado estará temporariamente indisponível em nosso aplicativo. Estamos realizando melhorias técnicas e atualizações na ferramenta para garantir um serviço ainda mais seguro e eficiente para você.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              'Se precisar do seu extrato de forma imediata, nossa equipe está pronta para atendê-lo e emitir o documento diretamente no setor de atendimento presencial da cooperativa.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              'Trabalhamos constantemente para evoluir nossos sistemas. Contamos com a sua compreensão.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 16),
            Text(
              'Equipe de TI e Atendimento Cocatrel.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text(
              'Entendido',
              style: TextStyle(
                color: AppColors.buttonTextLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  },
                          child: Row(

                            mainAxisSize: MainAxisSize.min,

                            children: [

                              SvgPicture.asset(AppAssets.exportNotes),

                              const SizedBox(width: 8),

                              Text(

                                'Gerar extrato',

                                style: AppFonts.textButton,

                              )

                            ],

                          )),

                    ],

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }



  showFarmOptionsDialog(BuildContext context, int? oldValue) {

    showOptionsDialog(

      context,

      title: 'Selecionar fazenda',

      content: ChangeNotifierProvider.value(

        value: coffeeMovementController,

        child: Column(

          children: [

            const Text('Selecione qual fazenda deseja ver o extrato do café'),

            const SizedBox(height: 16),

            Consumer<CoffeeMovementFilterController>(

                builder: (_, controller, __) {

              return Column(

                children: [

                  ...controller.farmOptions.asMap().entries.map(

                        (entity) => Column(

                          children: [

                            if (entity.key > 0) const DividerCardWidget(),

                            Row(

                              children: [

                                Expanded(

                                  child: Text(entity.value.title ?? ''),

                                ),

                                Radio(

                                  value: controller.currentOptionFarmIndex ==

                                      entity.key,

                                  onChanged: (value) {

                                    if (!(value ?? true)) {

                                      controller.changeCurrentOptionFarmIndex(

                                          entity.key);

                                    } else {

                                      controller

                                          .changeCurrentOptionFarmIndex(null);

                                    }

                                  },

                                  groupValue: true,

                                ),

                              ],

                            ),

                          ],

                        ),

                      )

                ],

              );

            }),

          ],

        ),

      ),

      actions: [

        TextButton(

          child: const Text(

            'Cancelar',

            style: TextStyle(

              color: AppColors.buttonTextLight,

              fontWeight: FontWeight.w600,

            ),

          ),

          onPressed: () {

            context

                .read<CoffeeMovementFilterController>()

                .changeCurrentOptionFarmIndex(oldValue);

            Navigator.of(context).pop();

          },

        ),

        TextButton(

          child: const Text(

            'Selecionar',

            style: TextStyle(

              color: AppColors.buttonTextLight,

              fontWeight: FontWeight.w600,

            ),

          ),

          onPressed: () {

            Navigator.of(context).pop();

          },

        ),

      ],

    );

  }



  showMovementTypeOptionsDialog(BuildContext context, int? oldValue) {

    showOptionsDialog(

      context,

      title: 'Selecionar movimento',

      content: ChangeNotifierProvider.value(

        value: coffeeMovementController,

        child: Column(

          children: [

            const Text(

                'Selecione qual qual o tipo de movimento deseja ver no extrato'),

            const SizedBox(height: 16),

            Consumer<CoffeeMovementFilterController>(

                builder: (_, controller, __) {

              return Column(

                children: [

                  ...controller.movementType.asMap().entries.map(

                        (entity) => Column(

                          children: [

                            if (entity.key > 0) const DividerCardWidget(),

                            Row(

                              children: [

                                Expanded(

                                  child: Text(entity.value.title ?? ''),

                                ),

                                Radio(

                                  value: controller

                                          .currentOptionMovementTypeIndex ==

                                      entity.key,

                                  onChanged: (value) {

                                    if (!(value ?? true)) {

                                      controller

                                          .changeCurrentOptionMovementTypeIndex(

                                              entity.key);

                                    } else {

                                      controller

                                          .changeCurrentOptionMovementTypeIndex(

                                              null);

                                    }

                                  },

                                  groupValue: true,

                                ),

                              ],

                            ),

                          ],

                        ),

                      )

                ],

              );

            }),

          ],

        ),

      ),

      actions: [

        TextButton(

          child: const Text(

            'Cancelar',

            style: TextStyle(

              color: AppColors.buttonTextLight,

              fontWeight: FontWeight.w600,

            ),

          ),

          onPressed: () {

            context

                .read<CoffeeMovementFilterController>()

                .changeCurrentOptionMovementTypeIndex(oldValue);

            Navigator.of(context).pop();

          },

        ),

        TextButton(

          child: const Text(

            'Selecionar',

            style: TextStyle(

              color: AppColors.buttonTextLight,

              fontWeight: FontWeight.w600,

            ),

          ),

          onPressed: () {

            Navigator.of(context).pop();

          },

        ),

      ],

    );

  }

}