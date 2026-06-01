import 'package:cocatrel/models/invoice_model.dart';
import 'package:cocatrel/repositories/invoice_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class InvoicesController extends ChangeNotifier {
  InvoicesController() {
    fetchInvoices();
  }

  bool loading = false;
  Either<Error, InvoiceList> invoices = Right(
    InvoiceList(invoices: [
      InvoiceModel(),
      InvoiceModel(),
    ]),
  );

  Future<void> fetchInvoices() async {
    loading = true;
    notifyListeners();

    final data = await InvoiceRepository.getInvoices();

    invoices = data;

    loading = false;
    notifyListeners();
  }
}
