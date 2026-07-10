import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/common/widgets/navigation_bar/market_navigation.dart';
import 'package:cocatrel/common/widgets/title/title.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeeSubtitlePage extends StatelessWidget {
  const CoffeeSubtitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const ProfileAppBar(
        showBackButton: true,
      ),
      bottomNavigationBar: const MarketNavigation(),
      drawer: const BasicMenuDrawer(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 32),
                  const BasicTitle(text: 'Legenda de bebida de café'),
                  _warning(),
                  const SizedBox(height: 16),
                  _item(
                    title: 'COC-CDT',
                    description:
                        'A partir de 85 pontos na metodologia SCA, na peneira 16 acima.',
                    color: const Color(0xFFB11E39),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC-CD1',
                    description:
                        'Bebida apenas mole ou melhor, cor esverdeado ou esverdeado/manchado, aspecto bom, seca boa/uniforme.',
                    color: const Color(0xFF24306A),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC-CD2',
                    description:
                        'Bebida dura, cor esverdeado ou manchado, aspecto regular, seca regular.',
                    color: const Color(0xFF0253A5),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC1',
                    description:
                        'Bebida mole, cor esverdeado ou esverdeado/manchado, aspecto bom, seca boa/uniforme.',
                    color: const Color(0xFF55210E),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC2',
                    description:
                        'Bebida apenas mole, cor esverdeado ou esverdeado/manchado, aspecto bom, seca boa/uniforme.',
                    color: const Color(0xFF84331A),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC3',
                    description:
                        'Bebida dura limpa, cor esverdeado ou esverdeado/manchado, aspecto bom, seca boa/uniforme.',
                    color: const Color(0xFFF36B33),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC4',
                    description:
                        'Bebida dura característica, pouco adstringente, cor esverdeado ou esverdeado/manchado, aspecto regular, seca boa.',
                    color: const Color(0xFF009B4E),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC5',
                    description:
                        'Bebida dura, cor manchado, aspecto desuniforme, seca regular.',
                    color: const Color(0xFFA2CE4F),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC6',
                    description:
                        'Bebida dura ou dura-suja ou dura-fermentada, cor discrepante, aspecto desuniforme/chuvado, seca desigual.',
                    color: const Color(0xFFE6E51F),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC7',
                    description:
                        'Bebida dura-riada ou riada, cor esverdeado/manchado, aspecto bom, seca boa/uniforme.',
                    color: const Color(0xFFF4D40D),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC8',
                    description:
                        'Bebida dura-riada ou riada, cor manchado/discrepante, aspecto desuniforme/chuvado, seca desigual.',
                    color: const Color(0xFFF7B118),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC9',
                    description:
                        'Bebida dura-riada-rio, cor esverdeado ou manchado ou discrepante, aspecto regular, seca regular.',
                    color: const Color(0xFFCB9A2C),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC10',
                    description:
                        'Bebida dura ou dura-riada ou riada ou dura-riada-rio, cor discrepante ou barrento, aspecto desuniforme/chuvado, seca desigual/má.',
                    color: const Color(0xFFF7F065),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC11',
                    description:
                        'Bebida rio, cor esverdeado ou esverdeado/manchado ou manchado, aspecto regular, seca boa.',
                    color: const Color(0xFFED4B24),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC12',
                    description:
                        'Bebida rio ou rio-sujo, cor discrepante ou barrento, aspecto desuniforme/chuvado, seca desigual.',
                    color: const Color(0xFFE51E25),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC13',
                    description:
                        'Café baixo livre de impurezas: repasse, resíduo, fundo, fundo de rebenefício.',
                    color: const Color(0xFFF06CA3),
                  ),
                  const SizedBox(height: 8),
                  _item(
                    title: 'COC14',
                    description:
                        'Café baixo com impurezas: escolha, bica podre.',
                    color: const Color(0xFF8C288D),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _warning() {
    return DefaultCardWidget(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.error_outline_outlined,
              color: AppColors.primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Cafes certificados: RFA - Premio: 20,00",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required String title,
    required String description,
    required Color color,
  }) {
    return DefaultCardWidget(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
