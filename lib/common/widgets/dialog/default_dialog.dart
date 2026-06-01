import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showDefaultDialog(
  BuildContext context, {
  required String title,
  required String contentText,
  EdgeInsets? insetPadding,
  List<Widget>? actions,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => DefaultAlertDialog(
      title: title,
      contentText: contentText,
      actions: actions,
      insetPadding: insetPadding,
    ),
  );
}

class DefaultAlertDialog extends StatelessWidget {
  const DefaultAlertDialog({
    required this.title,
    this.contentText,
    this.content,
    this.actions,
    this.insetPadding,
    super.key,
  });

  final String title;
  final String? contentText;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsets? insetPadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      actionsPadding: const EdgeInsets.all(16),
      insetPadding: insetPadding,
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
          child: contentText != null
              ? Text(contentText!)
              : content ?? const SizedBox(),
        ),
      ),
      actions: actions ??
          [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar'),
            )
          ],
    );
  }
}

showOptionsDialog(BuildContext context,
    {required String title,
    required Widget content,
    List<Widget>? actions}) async {
  await showDialog(
    context: context,
    builder: (_) => DefaultAlertDialog(
      title: title,
      content: content,
      actions: actions,
      insetPadding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * .2,
        horizontal: 16,
      ),
    ),
  );
}
