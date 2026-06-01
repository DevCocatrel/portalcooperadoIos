import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  // RegularBold
  static TextStyle title = const TextStyle(
    fontSize: 16,
    color: AppColors.textColor,
    fontWeight: FontWeight.w700,
  );

  static TextStyle textButton = const TextStyle(
    fontSize: 14,
    color: AppColors.buttonTextLight,
    fontWeight: FontWeight.w600,
  );

  static TextStyle text = GoogleFonts.montserrat(
    fontSize: 14,
    color: AppColors.textColor,
    fontWeight: FontWeight.w400,
  );
}
