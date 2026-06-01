import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthorizationSaleNavigation extends StatelessWidget {
  const AuthorizationSaleNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    var currentRoute = ModalRoute.of(context)?.settings.name;
    var currentIndex = 0;

    switch (currentRoute) {
      case AppRoutes.authorizationSaleListFarms:
        currentIndex = 0;
        break;
      case AppRoutes.authorizationPending:
        currentIndex = 1;
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
                icon: const Icon(Icons.house_outlined),
                label: 'Fazendas',
                selected: currentIndex == 0,
              ),
              _navigationBarItem(
                icon: const Icon(Icons.price_check_rounded),
                label: 'Autorizações',
                selected: currentIndex == 1,
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(
                      context, AppRoutes.authorizationSaleListFarms);
                  break;
                case 1:
                  Navigator.pushNamed(context, AppRoutes.authorizationPending);
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
