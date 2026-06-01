import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultCardWidget extends StatelessWidget {
  const DefaultCardWidget(
      {required this.child, this.margin, this.padding, super.key});

  final Widget child;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
