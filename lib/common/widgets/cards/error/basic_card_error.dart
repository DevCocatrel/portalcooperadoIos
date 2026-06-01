import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicCardError extends StatelessWidget {
  final String error;
  final Widget icon;

  const BasicCardError({
    super.key,
    required this.error,
    this.icon = const Icon(
      Icons.error,
      color: AppColors.textColor,
      size: 24,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return DefaultCardWidget(
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              icon,
              const SizedBox(height: 8),
              Text(
                textAlign: TextAlign.center,
                error,
                style: GoogleFonts.montserrat(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
