import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthorizationSection extends StatelessWidget {
  final Either<Error, DashboardData>? data;

  const AuthorizationSection({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    const title = "Autorização de venda pendente";

    if (data == null) {
      return _section(
        loading: true,
        title: title,
        authorizationsSalesPending: 1,
      );
    }

    return data!.fold((error) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BasicTitle(
              text: title,
            ),
            BasicCardError(
              error: "Erro ao carregar dados",
            ),
          ],
        ),
      );
    }, (certifies) {
      return _section(
        loading: false,
        title: title,
        authorizationsSalesPending: certifies.authorizationsSalesPending,
      );
    });
  }

  Widget _section({
    bool loading = false,
    required String title,
    required int authorizationsSalesPending,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            BasicTitle(text: title),
            if (authorizationsSalesPending == 0)
              const BasicCardError(
                icon: Icon(
                  Icons.check,
                  color: AppColors.primaryDark,
                  size: 24,
                ),
                error: "Você não possui autorizações de vendas pendentes",
              ),
            if (authorizationsSalesPending > 0)
              DefaultCardWidget(
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Autorizações pendentes",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColorLight,
                            ),
                          ),
                          Text(
                            authorizationsSalesPending.toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(42, 42),
                        ),
                        onPressed: () {
                          App.navigatorKey.currentState!
                              .pushNamed(AppRoutes.authorizationPending);
                        },
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 24,
                          color: AppColors.buttonTextLight,
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
