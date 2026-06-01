import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';

class BinarySelectionWidget extends StatelessWidget {
  const BinarySelectionWidget({
    super.key,
    required this.title,
    required this.option1,
    required this.option2,
    required this.optionSelected,
    required this.onTap1,
    required this.onTap2,
  });

  final String title;
  final String option1;
  final String option2;
  final String optionSelected;
  final void Function()? onTap1;
  final void Function()? onTap2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.text,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: AppColors.primaryColor,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap1,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(10),
                      ),
                      border: const Border(
                        right: BorderSide(
                          width: .5,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      color: option1 == optionSelected
                          ? AppColors.primaryLight
                          : null,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            if (option1 == optionSelected)
                              const WidgetSpan(
                                child: Icon(Icons.check, size: 18),
                              ),
                            if (option1 == optionSelected)
                              const TextSpan(text: ' '),
                            TextSpan(
                              text: option1,
                              style: option1 == optionSelected
                                  ? AppFonts.textButton.copyWith(
                                      fontSize: 14,
                                    )
                                  : AppFonts.text,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: onTap2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: option2 == optionSelected
                          ? AppColors.primaryLight
                          : null,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                      border: const Border(
                        left: BorderSide(
                          width: .5,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            if (option2 == optionSelected)
                              const WidgetSpan(
                                child: Icon(Icons.check, size: 18),
                              ),
                            if (option2 == optionSelected)
                              const TextSpan(text: ' '),
                            TextSpan(
                              text: option2,
                              style: option2 == optionSelected
                                  ? AppFonts.textButton.copyWith(
                                      fontSize: 14,
                                    )
                                  : AppFonts.text,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
