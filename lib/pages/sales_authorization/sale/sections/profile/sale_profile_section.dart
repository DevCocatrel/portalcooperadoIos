import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sale_controller.dart';
import 'package:cocatrel/pages/sales_authorization/sale/sections/profile/sale_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SaleProfileSection extends StatefulWidget {
  const SaleProfileSection({super.key});

  @override
  State createState() => _SaleProfileSectionState();
}

class _SaleProfileSectionState extends State<SaleProfileSection> {
  final SaleProfileController controller = SaleProfileController();

  @override
  void initState() {
    final controllerSale =
        Provider.of<SalePageController>(context, listen: false);

    controller.applicantNameController.text =
        controllerSale.applicantName ?? '';

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sale = Provider.of<SalePageController>(context, listen: false);

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<SaleProfileController>(
        builder: (context, value, child) {
          return Form(
            key: controller.formKey,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lotes autorizados para a venda',
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
                                Icons.person_outline_rounded,
                                color: AppColors.primaryDark,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Identificação",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            focusNode: controller.applicantNameControllerNode,
                            controller: controller.applicantNameController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Insira o nome solicitante';
                              } else if ((value?.length ?? 0) < 2) {
                                return 'Insira um nome válido';
                              }
                              return null;
                            },
                            style: GoogleFonts.montserrat(
                              color: AppColors.textColorLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: "Nome do solicitante",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  sale.previousStep();
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
                                    sale.setApplicantName(
                                      controller.applicantNameController.text,
                                    );
                                    sale.nextStep();
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
