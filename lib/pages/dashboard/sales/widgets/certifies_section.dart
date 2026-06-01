import 'package:cocatrel/common/widgets/cards/basic/basic_card.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/models/dashboard_certifies.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CertifiesSection extends StatelessWidget {
  final Either<Error, DashboardData>? data;

  const CertifiesSection({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    const title = "Minhas certificações";

    if (data == null) {
      return _section(
        loading: true,
        title: title,
        items: List.generate(
          2,
          (index) => DashboardCertifies(
            name: 'LRL',
            inscription: '000000000.00-00',
            farmName: 'Lorem Ipsum',
            expirationDate: '00/00/0000',
          ),
        ),
      );
    }

    return data!.fold(
      (error) {
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
      },
      (balance) {
        final certifies = balance.certifies;

        if (certifies.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicTitle(
                  text: title,
                ),
                BasicCardError(
                  icon: Icon(
                    Icons.check_outlined,
                    color: AppColors.primaryColorDark,
                  ),
                  error: "Nenhum certificado encontrado",
                ),
              ],
            ),
          );
        }

        return _section(
          loading: false,
          title: title,
          items: certifies,
        );
      },
    );
  }

  Widget _section({
    required String title,
    required List<DashboardCertifies> items,
    bool loading = false,
  }) {
    return Skeletonizer(
      enabled: loading,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            BasicTitle(text: title),
            ...items.asMap().entries.map(
              (entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;

                return Padding(
                  padding: isLast
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(bottom: 8),
                  child: BasicCard(
                    title: item.farmName,
                    icon: SvgPicture.asset(
                      AppAssets.newReleases,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryColorDark,
                        BlendMode.srcIn,
                      ),
                    ),
                    items: [
                      CardSingleItem(
                        title: 'Certificado',
                        value: Text(
                          item.name,
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CardSingleItem(
                        title: 'Vencimento',
                        value: Text(
                          item.expirationDate,
                          style: GoogleFonts.montserrat(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
