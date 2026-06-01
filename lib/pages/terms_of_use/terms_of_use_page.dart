import 'package:cocatrel/common/widgets/appbar/go_back_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/constants.dart';
import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const GoBackAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                  'Termo de uso da Plataforma e Política de Privacidade'),
              const SizedBox(height: 16),
              DefaultCardWidget(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      Text(
                        termsOfUse,
                        style: AppFonts.text.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
