import 'package:cocatrel/models/deposit_farm_list_model.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:cocatrel/repositories/deposit_slip_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class IssueInvoiceController extends ChangeNotifier {
  DepositSlip depositSlip = DepositSlip();

  IssueInvoiceController() {
    fetchFarms();
  }
  bool loadingFarms = false;

  Either<Error, DepositFarmListModel> depositFarms =
      Right(DepositFarmListModel.initialize());

  Future<void> fetchFarms() async {
    loadingFarms = true;
    notifyListeners();

    depositFarms = await DepositSlipRepository.getDepositFarmList();

    loadingFarms = false;
    notifyListeners();
  }

  void setCurrentFarm(
      {Farm? value, String? cooperatorName, String? registration}) {
    depositSlip = DepositSlip(
      farm: value,
      cooperatorName: cooperatorName,
      userRegistration: registration,
    );
    notifyListeners();
  }
}
