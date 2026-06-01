import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicMenuDrawer extends StatelessWidget {
  const BasicMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryColor,
      child: Column(
        children: <Widget>[
          _buildHeader(),
          _buildContent(context),
        ],
      ),
    );
  }

  Expanded _buildContent(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              // NOVO ITEM: Impactos da Reforma Tributária
              _buildItem(
                context: context,
                title: 'IMPACTOS DA REFORMA TRIBUTÁRIA',
                icon: const Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 24,
                  color: Colors.redAccent, // Destaca o ícone do PDF se quiser, ou use AppColors.buttonTextLight
                ),
                route: 'reforma_tributaria_pdf',
                onPressed: () {
                  // Aqui chamamos a rota de visualização de PDF do próprio app passando a URL
                  Navigator.of(context).pushNamed(
                    AppRoutes.laboratory, // <-- IMPORTANTE: Veja a nota abaixo sobre a rota correta
                    arguments: 'https://portal.cocatrel.com.br/pc/reformaTributariaExpocafe.pdf',
                  );
                },
              ),
              _buildItem(
                context: context,
                title: 'Painel de bordo',
                icon: const Icon(
                  Icons.home_outlined,
                  size: 24,
                ),
                route: AppRoutes.home,
              ),
              _buildItem(
                context: context,
                title: 'Saldo de café',
                icon: const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 24,
                ),
                route: AppRoutes.coffeeBalance,
              ),
              _buildItem(
                context: context,
                title: 'Autorização de venda',
                icon: SvgPicture.asset(
                  AppAssets.checkMarkPlus,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.buttonTextLight,
                    BlendMode.srcIn,
                  ),
                ),
                route: AppRoutes.authorizationSaleListFarms,
              ),
              _buildItem(
                context: context,
                title: 'Minhas Vendas',
                icon: const Icon(
                  Icons.shopping_cart_checkout_rounded,
                  size: 24,
                ),
                route: AppRoutes.myOrders,
              ),
              _buildItem(
                context: context,
                title: 'Guia de Depósito',
                icon: SvgPicture.asset(
                  AppAssets.pagePlus,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.buttonTextLight,
                    BlendMode.srcIn,
                  ),
                ),
                route: AppRoutes.indexDepositSlip,
              ),
              _buildItem(
                context: context,
                title: 'Títulos a pagar',
                icon: SvgPicture.asset(
                  AppAssets.pageDollar,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.buttonTextLight,
                    BlendMode.srcIn,
                  ),
                ),
                route: AppRoutes.bondsPayable,
              ),
              _buildItem(
                context: context,
                title: 'Boletos',
                icon: SvgPicture.asset(
                  AppAssets.barCode,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.buttonTextLight,
                    BlendMode.srcIn,
                  ),
                ),
                route: AppRoutes.invoices,
              ),
              _buildItem(
                context: context,
                title: 'Laboratório',
                icon: SvgPicture.asset(
                  AppAssets.laboratory,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.buttonTextLight,
                    BlendMode.srcIn,
                  ),
                ),
                route: AppRoutes.laboratory,
              ),
              _buildItem(
                context: context,
                title: 'Movimentação do Café',
                icon: const Icon(
                  Icons.compare_arrows_rounded,
                  size: 24,
                ),
                route: AppRoutes.coffeeMovementFilter,
              ),
              _buildItem(
                context: context,
                title: 'Serviços Cocatrel',
                icon: SvgPicture.asset(
                  AppAssets.trianglePlus,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.buttonTextLight,
                    BlendMode.srcIn,
                  ),
                ),
                route: AppRoutes.services,
              ),
              _buildItem(
                context: context,
                title: 'Mercado de Café',
                icon: SvgPicture.asset(
                  AppAssets.chartMagnifier,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.buttonTextLight,
                    BlendMode.srcIn,
                  ),
                ),
                route: AppRoutes.coffeeMarket,
              ),
              _buildItem(
                context: context,
                title: 'Bolsa de Commodities',
                icon: SvgPicture.asset(
                  AppAssets.chartLeft,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.buttonTextLight,
                    BlendMode.srcIn,
                  ),
                ),
                route: AppRoutes.commodityPricePage,
              ),
              _buildItem(
                context: context,
                title: 'Sair',
                icon: const Icon(Icons.exit_to_app_rounded),
                route: 'sair',
                onPressed: () {
                  AuthProvider.of(context).logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (_) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    return Container(
      height: 80,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 32, left: 16),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
      ),
      child: Image.asset(
        AppAssets.logo,
        height: 34,
        width: 181,
      ),
    );
  }

  _buildItem({
    required BuildContext context,
    required String title,
    required Widget icon,
    required String route,
    void Function()? onPressed,
  }) {
    var currentRoute = ModalRoute.of(context)?.settings.name;
    var isSelected = currentRoute?.contains(route) ?? false;

    return ElevatedButton(
      onPressed: onPressed ??
          () {
            if (!isSelected) {
              Navigator.of(context).pushNamed(route);
            }
          },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? AppColors.primaryColor : AppColors.backgroundColor,
        padding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 12,
        ),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color:
                  isSelected ? AppColors.buttonTextLight : AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
