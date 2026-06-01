import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/models/last_invoice_list.dart';
import 'package:cocatrel/repositories/deposit_slip_repository.dart';
import 'package:cocatrel/repositories/file_download_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class InvoiceListController extends ChangeNotifier {
  InvoiceListController() {
    fetchLastInvoiceList();
  }

  bool loading = false;
  Either<Error, LastInvoiceList> lastInvoiceList = Right(
    LastInvoiceList(farmList: [FarmModel()], nfeList: [NFeModel()]),
  );

  Future<void> fetchLastInvoiceList() async {
    loading = true;
    notifyListeners();

    lastInvoiceList = await DepositSlipRepository.getListInvoiceList();

    loading = false;
    notifyListeners();
  }

  String? loadingDownloadNFE;
  Future<void> downloadInvoicePdf(NFeModel nfe) async {
    if (loadingDownloadNFE != null) return;
    loadingDownloadNFE = nfe.accessKeyNumber;
    notifyListeners();

    final file = await FileDownloadRepository.downloadFileAsBase64(
      '/geraDanfe',
      {
        'IdNFe': nfe.registrationHan ?? '',
        'ChaveNFe': nfe.accessKeyNumber ?? '',
      },
      'nfe_${nfe.documentNumber}',
    );

    if (file.isRight) {
      successSnackBar('Arquivo salvo na pasta de downloads');
    } else {
      errorSnackBar('Erro ao baixar o arquivo');
    }

    loadingDownloadNFE = null;
    notifyListeners();
  }
}
