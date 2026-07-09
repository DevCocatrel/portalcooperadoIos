import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:cocatrel/repositories/deposit_slip_repository.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class ResumeController extends ChangeNotifier {
  ResumeController();

  bool loading = false;

  Future<bool> issueInvoice(DepositSlip depositSlip, String cooperatorName,
      String cooperatorRegistration) async {
    loading = true;
    notifyListeners();

    final result = await DepositSlipRepository.issueInvoice(depositSlip);

    loading = false;
    notifyListeners();

    if (result.isLeft) {
      return false;
    } else if (!result.right) {
      return false;
    }

    return true;
  }

  Future<void> issueInvoiceAndShowPdf(DepositSlip depositSlip) async {
    loading = true;
    notifyListeners();

    // Chama o NOVO método
    final result =
        await DepositSlipRepository.issueInvoiceAndGetPdf(depositSlip);

    loading = false;
    notifyListeners();

    result.fold(
      (errorMessage) {
        // Trate o erro (ex: mostrar Snackbar com a mensagem de erro)
      },
      (pdfBytes) async {
        // Abre o PDF automaticamente
        await Printing.layoutPdf(
          onLayout: (format) => pdfBytes,
          name: 'Romaneio_Cocatrel.pdf',
        );
      },
    );
  }
}
