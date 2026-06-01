import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';

class SessionExpiredPage extends StatefulWidget {
  const SessionExpiredPage({super.key});

  @override
  State<SessionExpiredPage> createState() => _SessionExpiredPageState();
}

class _SessionExpiredPageState extends State<SessionExpiredPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          leading: const SizedBox(),
          centerTitle: true,
          title: Image.asset(
            AppAssets.logo,
            fit: BoxFit.fill,
            height: 24,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.warningLight,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_clock_outlined,
                        size: 38,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sessão Expirada',
                    textAlign: TextAlign.center,
                    style: AppFonts.text.copyWith(
                      color: AppColors.textColorLight,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login, (_) => false);
                    },
                    child: const Text('Entrar Novamente'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            DefaultCardWidget(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 36)
                  .copyWith(bottom: 52),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'O tempo de sua sessão chegou ao limite. Por favor, faça login novamente para continuar usando o app',
                    style: AppFonts.text.copyWith(
                      color: AppColors.textColorLight,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
