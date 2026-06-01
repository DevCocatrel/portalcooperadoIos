import 'package:cocatrel/common/widgets/dialog/basic_dialog.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/models/order_authorization_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthorizationDialog extends StatefulWidget {
  final String saleExpirationDate;
  final List<OrderAuthorizationModel> authorizations;
  final String saleStatus;

  const AuthorizationDialog({
    super.key,
    required this.authorizations,
    required this.saleExpirationDate,
    required this.saleStatus,
  });

  @override
  AuthorizationDialogState createState() => AuthorizationDialogState();
}

class AuthorizationDialogState extends State<AuthorizationDialog> {
  OrderAuthorizationModel? selectedAuthorization;

  @override
  void initState() {
    super.initState();

    var isEmpty = widget.authorizations.isEmpty;

    if (!isEmpty) {
      selectedAuthorization = widget.authorizations.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showDialog(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.addNotes,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.buttonTextLight,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Ver autorizações",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.buttonTextLight,
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return BasicAlertDialog(
            title: 'Autorizações',
            content: Column(
              children: [
                Text(
                  "Selecione qual autorização você deseja ver os detalhes.",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColorLight,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    ...widget.authorizations.asMap().entries.map((entry) {
                      final authorization = entry.value;

                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.borderColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 6),
                          leading: Text(
                            authorization.authorizationNumber,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor,
                            ),
                          ),
                          trailing: Transform.scale(
                            scale: 1.1,
                            child: Radio(
                              fillColor: WidgetStateProperty.all(
                                authorization.authorizationNumber ==
                                        selectedAuthorization
                                            ?.authorizationNumber
                                    ? AppColors.primaryColor
                                    : AppColors.borderDarkColor,
                              ),
                              activeColor: AppColors.primaryColor,
                              value: authorization.authorizationNumber,
                              groupValue:
                                  selectedAuthorization?.authorizationNumber,
                              onChanged: (value) {
                                setState(() {
                                  selectedAuthorization = authorization;
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                )
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedAuthorization = null;
                  });

                  Navigator.pop(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    "Cancelar",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.buttonTextLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  if (selectedAuthorization == null) {
                    return;
                  }

                  var authorizationNumber =
                      selectedAuthorization!.authorizationNumber;
                  var saleNumber = selectedAuthorization!.saleNumber;
                  var authorizationDate =
                      selectedAuthorization!.authorizationDate;

                  Navigator.pop(context);

                  Navigator.pushNamed(
                    context,
                    AppRoutes.myOrderDetails,
                    arguments: {
                      'authorizationNumber': authorizationNumber,
                      'saleNumber': saleNumber,
                      'authorizationDate': authorizationDate,
                      'saleExpirationDate': widget.saleExpirationDate,
                      'saleStatus': widget.saleStatus,
                    },
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    "Selecionar",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.buttonTextLight,
                    ),
                  ),
                ),
              )
            ],
          );
        });
      },
    );
  }
}
