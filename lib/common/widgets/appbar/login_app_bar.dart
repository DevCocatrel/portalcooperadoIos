import 'package:cocatrel/common/widgets/dropdown/basic_dropdown.dart';
import 'package:cocatrel/common/widgets/dropdown/item/basic_dropdown_menu_item.dart';
import 'package:cocatrel/common/widgets/dropdown/menu/basic_dropdown_menu.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.primaryColor,
      toolbarHeight: 112,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(),
      elevation: 0,
      centerTitle: false,
      title: Image.asset(
        AppAssets.logo,
        height: 34,
        width: 181,
        fit: BoxFit.contain,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: BasicDropdown(
            alignment: DropDownAlignment.left,
            menu: BasicDropdownMenu(
              items: [
                BasicDropdownMenuItem(
                  isOnly: true,
                  text: "Acesso Administrativo",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.loginAdmin);
                  },
                  icon: SvgPicture.asset(
                    AppAssets.shieldPerson,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.buttonTextLight,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            button: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.more_vert,
                size: 28,
                color: AppColors.buttonTextLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(112);
}
