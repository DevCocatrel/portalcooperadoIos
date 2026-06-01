import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TitleWithIconCardWidget extends StatelessWidget {
  const TitleWithIconCardWidget({
    required this.title,
    required this.icon,
    this.titleFontSize,
    this.svgPath,
    super.key,
  });

  final String title;
  final String? svgPath;
  final IconData icon;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          svgPath != null
              ? SvgPicture.asset(
                  svgPath!,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryDark,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(
                  icon,
                  color: AppColors.primaryDark,
                ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: AppColors.primaryDark, fontSize: titleFontSize),
            ),
          )
        ],
      ),
    );
  }
}
