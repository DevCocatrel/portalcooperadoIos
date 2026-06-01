import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/dialog/default_dialog.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/dropdown/basic_dropdown.dart';
import 'package:cocatrel/common/widgets/dropdown/item/basic_dropdown_menu_item.dart';
import 'package:cocatrel/common/widgets/dropdown/menu/basic_dropdown_menu.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/date.dart';
import 'package:cocatrel/models/bulletin_model.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:cocatrel/pages/laboratory/laboratory_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LaboratoryPage extends StatelessWidget {
  LaboratoryPage({super.key});

  final laboratoryController = LaboratoryController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: laboratoryController,
      child: DefaultScaffoldWidget(
        drawer: const BasicMenuDrawer(),
        appBar: const ProfileAppBar(
          title: 'Laboratório',
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await laboratoryController.fetchBulletinList();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text('Relação de boletins'),
              ),
              DefaultCardWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.article_outlined,
                            color: AppColors.primaryDark),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Selecionar um período',
                            style: TextStyle(color: AppColors.primaryDark),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    _dropdownWidget(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: laboratoryController.fetchBulletinList,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.exportNotes,
                            colorFilter: const ColorFilter.mode(
                              AppColors.buttonTextLight,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Gerar boletim',
                            style: AppFonts.textButton,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Consumer<LaboratoryController>(builder: (context, controller, _) {
                return Skeletonizer(
                  enabled: controller.loadingBulletinList,
                  child: Column(
                    children: [
                      if (controller.bulletinList.isRight &&
                          controller.bulletinList.right.isNotEmpty) ...{
                        ...controller.bulletinList.right.map(
                          (item) => bulletinItemWidget(item, controller),
                        ),
                      } else if (controller.bulletinList.isLeft)
                        const BasicCardError(error: 'Erro ao carregar boletins')
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  DefaultCardWidget bulletinItemWidget(
    BulletinModel item,
    LaboratoryController controller,
  ) {
    return DefaultCardWidget(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${item.bulletinCode ?? ''}',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: controller.loadingBulletinList
                      ? null
                      : item.bulletinPaid == 'S'
                          ? AppColors.successLight
                          : AppColors.warningLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.bulletinPaid == 'S'
                          ? Icons.check_rounded
                          : Icons.schedule_rounded,
                      size: 16,
                      color: item.bulletinPaid == 'S'
                          ? AppColors.successDark
                          : AppColors.warningDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.bulletinPaid == 'S' ? 'Pago' : 'Pendente',
                      style: AppFonts.textButton.copyWith(
                        fontSize: 14,
                        color: item.bulletinPaid == 'S'
                            ? AppColors.successDark
                            : AppColors.warningDark,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RowWithDataWidget(
              title: 'Propriedade', value: item.propertyName ?? ''),
          const DividerCardWidget(),
          RowWithDataWidget(
              title: 'Entrada', value: normalizeDate(item.entryDate ?? '')),
          const DividerCardWidget(),
          RowWithDataWidget(
              title: 'Conclusão',
              value: normalizeDate(item.completionDate ?? '')),
          const DividerCardWidget(),
          RowWithDataWidget(title: 'Tipo', value: item.bulletinType ?? ''),
          const SizedBox(height: 16),
          if (item.bulletinPaid == 'S')
            BasicDropdown(
              menu: BasicDropdownMenu(
                items: [
                  BasicDropdownMenuItem(
                    isFirst: true,
                    isLast: false,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    text: 'Baixar boletim em PDF',
                    onPressed: () {
                      controller.downloadFile(
                        item.bulletinCode ?? '',
                        item.bulletinType ?? '',
                        'print',
                      );
                    },
                  ),
                  BasicDropdownMenuItem(
                    isFirst: false,
                    isLast: true,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    text: 'Baixar boletim em Excel',
                    onPressed: () {
                      controller.downloadFile(
                        item.bulletinCode ?? '',
                        item.bulletinType ?? '',
                        'excel',
                      );
                    },
                  ),
                ],
              ),
              button: Container(
                height: 42,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.loadingDownloadBulletin == item.bulletinCode
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.file_download_outlined),
                    const SizedBox(width: 8),
                    Text(
                      'Baixar boletim',
                      style: AppFonts.textButton,
                    )
                  ],
                ),
              ),
              alignment: DropDownAlignment.right,
            ),
        ],
      ),
    );
  }

  Widget _dropdownWidget() {
    return Form(
      key: laboratoryController.formKey,
      child: Consumer<LaboratoryController>(builder: (context, controller, _) {
        return Stack(
          children: [
            DropdownButtonFormField<int>(
              items: const [],
              onChanged: (int? value) {},
              hint: Text('${controller.currentYear ?? 'Selecione o ano'}'),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.textColorLight,
              ),
              validator: (value) {
                if (controller.currentYear == null) {
                  return 'Selecione um ano para gerar o boletim';
                }
                return null;
              },
            ),
            Positioned.fill(
              child: InkWell(
                onTap: () async {
                  var value = controller.currentYear;

                  await showOptionsDialog(
                    context,
                    title: 'Boletins',
                    content: ChangeNotifierProvider.value(
                      value: controller,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Consumer<LaboratoryController>(
                            builder: (context_, controller, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Selecione o ano'),
                              const SizedBox(height: 16),
                              ...controller.years.right
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map(
                                    (item) => Column(
                                      children: [
                                        if (item.key != 0)
                                          const DividerWidget(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.value.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Radio(
                                              value: item.value,
                                              groupValue:
                                                  controller.currentYear,
                                              onChanged:
                                                  controller.changeCurrentYear,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                            ],
                          );
                        }),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          controller.changeCurrentYear(value);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancelar',
                          style: AppFonts.textButton.copyWith(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          value = controller.currentYear;
                        },
                        child: Text(
                          'Selecionar',
                          style: AppFonts.textButton,
                        ),
                      ),
                    ],
                  );
                  controller.changeCurrentYear(value);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
