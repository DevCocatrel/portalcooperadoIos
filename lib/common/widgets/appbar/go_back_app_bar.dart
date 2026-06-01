import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GoBackAppBar({this.title, super.key});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.primaryColor,
      leadingWidth: 105,
      toolbarHeight: 112,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(),
      elevation: 0.00,
      title: leadingButton(context),
      centerTitle: false,
      bottom: title != null ? _bottom(context) : null,
    );
  }

  Widget leadingButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
      ),
      onPressed: () {
        final canPop = Navigator.of(context).canPop();

        if (canPop) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushNamed(AppRoutes.home);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.arrow_back,
            color: AppColors.buttonTextLight,
          ),
          const SizedBox(width: 8),
          Text(
            'Voltar',
            style: GoogleFonts.montserrat(
              color: AppColors.buttonTextLight,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _bottom(BuildContext context) {
    const Size size = Size.fromHeight(56);
    const double height = 56;

    return PreferredSize(
      preferredSize: size,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: height,
        alignment: Alignment.centerLeft,
        child: Text(
          title!,
          style: const TextStyle(
            color: AppColors.buttonTextLight,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(112);
}
