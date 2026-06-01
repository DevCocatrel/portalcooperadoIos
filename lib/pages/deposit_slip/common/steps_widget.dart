import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';

class StepsWidget extends StatelessWidget {
  const StepsWidget(this.currentStep, this.title, {super.key});

  final int currentStep;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Row(
          children: [
            stepItemWidget(1),
            stepDividerWidget(1),
            stepItemWidget(2),
            stepDividerWidget(2),
            stepItemWidget(3),
            stepDividerWidget(3),
            stepItemWidget(4),
          ],
        ),
        const SizedBox(height: 16),
        Text(title),
        const SizedBox(height: 26),
      ],
    );
  }

  Widget stepDividerWidget(int afterStep) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 2,
        color: currentStep > afterStep
            ? AppColors.primaryColor
            : AppColors.borderColor,
      ),
    );
  }

  Container stepItemWidget(int item) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: currentStep >= item
              ? AppColors.primaryColor
              : AppColors.borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: currentStep > item ? AppColors.primaryColor : null,
      ),
      child: Text(
        item.toString(),
        style: AppFonts.textButton.copyWith(
          color: currentStep == item
              ? AppColors.primaryColor
              : currentStep > item
                  ? Colors.white
                  : AppColors.textColor,
        ),
      ),
    );
  }
}
