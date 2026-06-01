import 'package:cocatrel/common/widgets/cards/basic/basic_card.dart';
import 'package:cocatrel/common/widgets/cards/error/basic_card_error.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- IMPORTANTE: Importamos o abridor de links

class PanelSection extends StatelessWidget {
  final Either<Error, DashboardData>? panel;

  const PanelSection({super.key, this.panel});

  @override
  Widget build(BuildContext context) {
    const title = "Panel de bordo";

    if (panel == null) {
      return _section(
        loading: true,
        title: title,
        year: "0000",
        balance: 0.00,
        availableBalance: 0.00,
      );
    }

    return panel!.fold(
      (error) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adicionado aqui também para o caso de a API dar erro, o botão do PDF continuar visível no topo
              _buildReformaTributariaButton(),
              const SizedBox(height: 15),
              const BasicTitle(
                text: title,
              ),
              const BasicCardError(
                error: "Erro ao carregar dados",
              ),
            ],
          ),
        );
      },
      (balance) {
        return _section(
          title: title,
          year: balance.leftOversYear,
          balance: balance.leftoversBalance,
          availableBalance: balance.leftoversAvailableBalance,
        );
      },
    );
  }

  // FUNÇÃO AUXILIAR: Cria o botão estilizado do PDF
  Widget _buildReformaTributariaButton() {
    final Uri url = Uri.parse('https://portal.cocatrel.com.br/pc/reformaTributariaExpocafe.pdf');

    return GestureDetector(
      onTap: () async {
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Não foi possível abrir o link $url');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F), // Vermelho elegante para destacar o PDF / Reforma
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'IMPACTOS DA REFORMA TRIBUTÁRIA',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String year,
    required double balance,
    required double availableBalance,
    bool loading = false,
  }) {
    final balanceFormatted = Currency.format(balance);

    final availableBalanceFormatted = Currency.format(
      availableBalance,
    );

    return Skeletonizer(
      enabled: loading,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOVO ITEM: O botão fica estrategicamente posicionado no topo da seção
            _buildReformaTributariaButton(),
            const SizedBox(height: 20), // Espaçamento entre o botão e o título abaixo
            
            const BasicTitle(text: "Painel de bordo"),
            BasicCard(
              fullWidth: true,
              customTitle: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.attachMoneyArrowDown,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryColorDark,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sobras de $year referente ao exercício de ${int.parse(year) - 1}',
                      style: GoogleFonts.montserrat(
                        color: AppColors.primaryColorDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
              title: '',
              items: [
                CardSingleItem(
                  title: 'Valor liberado',
                  value: Text(
                    balanceFormatted,
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CardSingleItem(
                  title: 'Disponível',
                  value: Text(
                    availableBalanceFormatted,
                    style: GoogleFonts.montserrat(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}