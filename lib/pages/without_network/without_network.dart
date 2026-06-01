import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_assets.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

class WithoutNetworkPage extends StatefulWidget {
  const WithoutNetworkPage({super.key});

  @override
  State<WithoutNetworkPage> createState() => _WithoutNetworkPageState();
}

class _WithoutNetworkPageState extends State<WithoutNetworkPage> {
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
                        Icons.wifi_off_outlined,
                        size: 38,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sem conexão com a internet!\nVerifique sua conexão e tente novamente.',
                    textAlign: TextAlign.center,
                    style: AppFonts.text.copyWith(
                      color: AppColors.textColorLight,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: () async {
                        final status = await InternetConnection.createInstance()
                            .internetStatus;
                        if (InternetStatus.connected == status) {
                          if (context.mounted) {
                            final authProvider = context.read<AuthProvider>();

                            if (authProvider.user == null) {
                              await authProvider.initializeWithSplash();
                            } else {
                              final canPop = Navigator.of(context).canPop();

                              if (canPop) {
                                Navigator.of(context).pop();
                                return;
                              }
                            }

                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  authProvider.initialRoute, (_) => false);
                            }
                          }
                        }
                      },
                      child: const Text('Tentar novamente')),
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
                    'Você está offline. Para aproveitar todas as funcionalidades do aplicativo e garantir o funcionamento correto, conecte-se a uma rede e tente novamente.',
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
