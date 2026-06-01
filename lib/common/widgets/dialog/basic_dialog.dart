import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showBasicDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  List<Widget>? actions,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => BasicAlertDialog(
      title: title,
      content: content,
      actions: actions,
    ),
  );
}

class BasicAlertDialog extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget content;

  const BasicAlertDialog({
    super.key,
    this.actions,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      actionsPadding: const EdgeInsets.all(16),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor,
        ),
      ),
      content: Scrollbar(
        child: SingleChildScrollView(
          child: content,
        ),
      ),
      actions: actions,
    );
  }
}
