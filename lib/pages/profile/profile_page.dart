import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);

    return DefaultScaffoldWidget(
      drawer: const BasicMenuDrawer(),
      appBar: const ProfileAppBar(
        title: 'Meus dados',
        showMyData: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Cooperado'),
              const SizedBox(height: 16),
              DefaultCardWidget(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.primaryDark,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              auth.user?.formattedName ?? 'Cooperado',
                              style: GoogleFonts.montserrat(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Código de associado',
                        style: AppFonts.text,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        auth.user?.registration ?? '',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('CPF', style: AppFonts.text),
                      const SizedBox(height: 8),
                      Text(
                        auth.user!.cpfCnpj ?? '',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Data de nascimento', style: AppFonts.text),
                      const SizedBox(height: 8),
                      Text(
                        auth.user!.showBirthday,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Segurança'),
              const SizedBox(height: 16),
              DefaultCardWidget(
                  child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minha senha',
                      style: AppFonts.text,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '**********',
                      style: AppFonts.text,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.changePassword);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Alterar senha'),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(Icons.arrow_forward_rounded),
                          ],
                        ))
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
