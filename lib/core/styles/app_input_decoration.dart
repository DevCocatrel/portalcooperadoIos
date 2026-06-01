import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';

final focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(6),
  borderSide: const BorderSide(
    width: 1,
    color: AppColors.borderDarkColor,
  ),
);
final border = OutlineInputBorder(
  gapPadding: 8,
  borderSide: const BorderSide(
    color: AppColors.borderColor,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(6),
);
