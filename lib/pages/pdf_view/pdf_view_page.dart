import 'package:cocatrel/common/widgets/appbar/go_back_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFPage extends StatefulWidget {
  const PDFPage({
    this.title,
    this.filePath,
    this.pdfData,
    super.key,
  });

  final Uint8List? pdfData;
  final String? filePath;
  final String? title;

  @override
  State<PDFPage> createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: GoBackAppBar(
        title: widget.title,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: PDFView(
          filePath: widget.filePath,
          pdfData: widget.pdfData,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onRender: (page) {},
          onError: (error) {},
          onPageError: (page, error) {},
          onPageChanged: (int? page, int? total) {},
        ),
      ),
    );
  }
}
