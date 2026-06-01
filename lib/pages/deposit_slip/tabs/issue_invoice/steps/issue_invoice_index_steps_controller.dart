import 'package:cocatrel/models/coffee_entry_model.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:cocatrel/repositories/deposit_slip_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IssueInvoiceIndexController extends ChangeNotifier {
  factory IssueInvoiceIndexController.of(BuildContext context) {
    return context.read<IssueInvoiceIndexController>();
  }

  IssueInvoiceIndexController(
    this.depositSlip,
    this.tabController,
  ) {
    fetchCoffeeEntry();
    fetchTractorList();
  }

  TabController tabController;

  DepositSlip depositSlip;

  bool loadingCoffeeEntry = false;

  Either<Error, CoffeeEntryModel> coffeeEntry = Right(
    CoffeeEntryModel.initialize(),
  );

  bool loadingTractors = false;
  Either<Error, List<String>> tractorList = const Right([]);

  Future<void> fetchTractorList() async {
    loadingTractors = true;
    notifyListeners();

    tractorList = await DepositSlipRepository.getTractorList();

    loadingTractors = false;
    notifyListeners();
  }

  Future<void> fetchCoffeeEntry() async {
    if (depositSlip.farm == null) return;
    if (loadingCoffeeEntry) return;

    loadingCoffeeEntry = true;
    notifyListeners();

    coffeeEntry = await DepositSlipRepository.getCoffeeEntryModel(
      depositSlip.farm?.registrationNumber ?? '',
    );

    if (coffeeEntry.isRight) {
      depositSlip.farmCertificates = coffeeEntry.right.farmCertificates;
      depositSlip.farmCertificateCode = coffeeEntry.right.farmCertificateCode;
      depositSlip.coffeePrice = coffeeEntry.right.coffeePrice;
    } else {
      depositSlip.farmCertificates = null;
      depositSlip.farmCertificateCode = null;
    }

    loadingCoffeeEntry = false;
    notifyListeners();
  }
}
