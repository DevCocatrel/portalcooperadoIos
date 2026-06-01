import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DepositSlipNavigationBar extends StatelessWidget {
  const DepositSlipNavigationBar(this.tabController, this.onTap, {super.key});

  final TabController tabController;

  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          currentIndex: tabController.index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          unselectedLabelStyle: AppFonts.text,
          selectedLabelStyle: AppFonts.text,
          unselectedIconTheme: const IconThemeData(
            color: AppColors.textColor,
          ),
          selectedIconTheme: const IconThemeData(
            color: AppColors.primaryColorDark,
          ),
          iconSize: 24,
          items: [
            _navigationBarItem(
              icon: SvgPicture.asset(AppAssets.addNotes),
              label: 'Emitir NFE',
              selected: tabController.index == 0,
            ),
            _navigationBarItem(
                icon: const Icon(Icons.article_outlined),
                label: 'Últimas emissões',
                selected: tabController.index == 1)
          ],
          onTap: onTap,
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
