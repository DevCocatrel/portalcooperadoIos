import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';

class RowWithDataWidget extends StatelessWidget {
  const RowWithDataWidget({
    super.key,
    required this.title,
    required this.value,
    this.valueWidget,
  });

  final String title;
  final String value;

  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppFonts.text.copyWith(
            color: AppColors.textColorLight,
          ),
        ),
        Expanded(
          child: valueWidget ??
              Text(
                value,
                textAlign: TextAlign.right,
                style: AppFonts.text.copyWith(
                  color: AppColors.textColorLight,
                ),
              ),
        ),
      ],
    );
  }
}
