import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: AppColors.borderColor,
        height: 1,
      ),
    );
  }
}

class DividerCardWidget extends StatelessWidget {
  const DividerCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: const DividerWidget(),
    );
  }
}
