import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardSingleItem {
  String? title;
  Widget? value;

  CardSingleItem({this.title, this.value});
}

class BasicCard extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget? icon;
  final List<CardSingleItem> items;
  final Function()? onPressed;
  final bool fullWidth;
  final Widget? customTitle;

  const BasicCard({
    super.key,
    this.icon,
    this.onPressed,
    this.subTitle,
    this.fullWidth = false,
    required this.items,
    required this.title,
    this.customTitle,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultCardWidget(
      child: SizedBox(
        width: fullWidth == true ? double.infinity : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTitle != null
                ? customTitle!
                : Row(
                    // spaceBetween
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (icon != null) icon!,
                          if (icon != null) const SizedBox(width: 10),
                          Text(
                            title,
                            style: GoogleFonts.montserrat(
                              color: AppColors.primaryColorDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      if (subTitle != null)
                        Text(
                          subTitle!,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        )
                    ],
                  ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isLast = index == items.length - 1;

                    return Container(
                      padding: isLast == false
                          ? const EdgeInsets.only(right: 20)
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.title != null)
                            Text(
                              item.title!,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColorLight,
                              ),
                            ),
                          if (item.title != null) const SizedBox(height: 4),
                          if (item.value != null) item.value!,
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (onPressed != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(42, 42),
                    ),
                    onPressed: onPressed,
                    child: const Icon(
                      Icons.add,
                      size: 24,
                      color: AppColors.buttonTextLight,
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
