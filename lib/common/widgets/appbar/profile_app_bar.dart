import 'package:cocatrel/common/widgets/dropdown/basic_dropdown.dart';
import 'package:cocatrel/common/widgets/dropdown/item/basic_dropdown_menu_item.dart';
import 'package:cocatrel/common/widgets/dropdown/menu/basic_dropdown_menu.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/launch_whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showMyData;

  final bool isHomePage;

  final void Function()? goBackFunction;

  const ProfileAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showMyData = true,
    this.goBackFunction,
    this.isHomePage = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(112);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.primaryColor,
      toolbarHeight: 112,
      centerTitle: false,
      title: InkWell(
        overlayColor:
            WidgetStateProperty.resolveWith((_) => Colors.transparent),
        onTap: isHomePage
            ? null
            : () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (_) => false,
                );
              },
        child: Image.asset(
          AppAssets.logo,
          height: 28,
        ),
      ),
      leadingWidth: 40,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(
          size: 24,
          Icons.menu_rounded,
          color: AppColors.buttonTextLight,
        ),
      ),
      actions: _actions(context),
      bottom: _bottom(context),
    );
  }

  PreferredSize _bottom(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    const Size size = Size.fromHeight(56);
    const double height = 56;

    if (title != null && title!.isNotEmpty) {
      return PreferredSize(
        preferredSize: size,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: height,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: GoogleFonts.montserrat(
                  color: AppColors.buttonTextLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.house_outlined,
                        color: AppColors.buttonTextLight,
                      ),
                      Text(
                        'Início',
                        style: AppFonts.textButton.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    if (showBackButton) {
      return PreferredSize(
        preferredSize: size,
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 20),
          alignment: Alignment.centerLeft,
          height: height,
          child: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            iconSize: 24,
            onPressed: () {
              if (goBackFunction != null) {
                goBackFunction!();
                return;
              }
              final canPop = Navigator.of(context).canPop();

              if (canPop) {
                Navigator.of(context).pop();
              }
            },
            icon: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
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
          ),
        ),
      );
    }

    return PreferredSize(
      preferredSize: size,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: height,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const Icon(
              size: 32,
              Icons.account_circle_rounded,
              color: AppColors.buttonTextLight,
            ),
            const SizedBox(width: 8),
            Text(
              (user != null ? user.formattedName : 'Cooperado') ?? 'Cooperado',
              style: const TextStyle(
                color: AppColors.buttonTextLight,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: BasicDropdown(
          menu: BasicDropdownMenu(
            items: [
              BasicDropdownMenuItem(
                isFirst: true,
                text: "Ouvidoria",
                icon: const Icon(
                  size: 24,
                  Icons.headset_mic_outlined,
                  color: AppColors.buttonTextLight,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.ombudsman);
                },
              ),
              BasicDropdownMenuItem(
                isLast: true,
                text: "Fale Conosco",
                icon: const Icon(
                  size: 24,
                  Icons.local_phone_outlined,
                  color: AppColors.buttonTextLight,
                ),
                onPressed: () async {
                  await launchWhatsApp(context);
                },
              ),
            ],
          ),
          button: const Icon(
            size: 24,
            Icons.headset_mic_outlined,
            color: AppColors.buttonTextLight,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: BasicDropdown(
          menu: BasicDropdownMenu(
            items: [
              if (showMyData)
                BasicDropdownMenuItem(
                  isFirst: true,
                  text: "Meus dados",
                  icon: const Icon(
                    size: 24,
                    Icons.account_circle_outlined,
                    color: AppColors.buttonTextLight,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.profile);
                  },
                ),
              BasicDropdownMenuItem(
                isLast: true,
                isFirst: !showMyData,
                text: "Sair",
                icon: const Icon(
                  size: 24,
                  Icons.logout,
                  color: AppColors.buttonTextLight,
                ),
                onPressed: () {
                  auth.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (_) => false,
                  );
                },
              ),
            ],
          ),
          button: const Icon(
            size: 24,
            Icons.account_circle_outlined,
            color: AppColors.buttonTextLight,
          ),
        ),
      ),
    ];
  }
}
