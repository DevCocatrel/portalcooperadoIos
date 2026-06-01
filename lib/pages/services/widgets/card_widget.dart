import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/repositories/file_download_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    super.key,
    required this.icon,
    required this.linkPDF,
    required this.title,
  });

  final IconData icon;
  final String title;
  final String linkPDF;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return DefaultCardWidget(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              widget.icon,
              color: AppColors.primaryColorDark,
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primaryColorDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              final pdfData = await FileDownloadRepository.downloadFileAsBinary(
                  widget.linkPDF);
              setState(() {
                loading = false;
              });

              if (pdfData != null && context.mounted) {
                Navigator.of(context).pushNamed(AppRoutes.pdfPage, arguments: {
                  'pdfData': pdfData,
                  'title': widget.title,
                });
              } else if (pdfData == null) {
                errorSnackBar('Error ao baixar PDF');
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.file_download_outlined),
                const SizedBox(width: 8),
                Text(
                  'Baixar PDF',
                  style: AppFonts.title.copyWith(
                    color: AppColors.buttonTextLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ))
      ],
    ));
  }
}
