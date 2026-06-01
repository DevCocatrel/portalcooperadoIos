import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardNavigation extends StatelessWidget {
  const DashboardNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    var currentRoute = ModalRoute.of(context)?.settings.name;
    var currentIndex = 0;

    switch (currentRoute) {
      case AppRoutes.home:
        currentIndex = 0;
        break;
      case AppRoutes.balance:
        currentIndex = 1;
        break;
      case AppRoutes.farms:
        currentIndex = 2;
        break;
      case AppRoutes.sales:
        currentIndex = 3;
        break;
      default:
        currentIndex = 0;
    }

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        color: AppColors.backgroundColor,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.borderColor,
              width: 1,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            unselectedLabelStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textColor,
            ),
            selectedLabelStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryColorDark,
            ),
            unselectedIconTheme: const IconThemeData(
              color: AppColors.textColor,
            ),
            selectedIconTheme: const IconThemeData(
              color: AppColors.primaryColorDark,
            ),
            iconSize: 24,
            items: [
              _navigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.chartRoundedArrow,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    currentIndex == 0
                        ? AppColors.primaryColorDark
                        : AppColors.textColor,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Bolsa',
                selected: currentIndex == 0,
              ),
              _navigationBarItem(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                label: 'Saldo',
                selected: currentIndex == 1,
              ),
              _navigationBarItem(
                icon: const Icon(Icons.agriculture_outlined),
                label: 'Fazendas',
                selected: currentIndex == 2,
              ),
              _navigationBarItem(
                icon: const Icon(Icons.account_balance_outlined),
                label: 'Vendas',
                selected: currentIndex == 3,
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, AppRoutes.balance);
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, AppRoutes.farms);
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, AppRoutes.sales);
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navigationBarItem({
    required Widget icon,
    required String label,
    required bool selected,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: icon,
      ),
      label: label,
    );
  }
}
