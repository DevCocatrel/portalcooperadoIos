import 'package:cocatrel/models/coffee_entry_model.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:flutter/material.dart';

class DeliveryInformationController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  DeliveryInformationController(this.depositSlip);
  DepositSlip depositSlip;

  final emailTextController = TextEditingController();

  void changeWarehouse(WarehouseModel? value) {
    depositSlip.warehouse = value;

    notifyListeners();
  }

  void changePackaging(PackagingModel? value) {
    depositSlip.packaging = value;

    notifyListeners();
  }

  bool validate() {
    if (formKey.currentState!.validate()) {
      depositSlip.emailNFE = emailTextController.text;
      return true;
    }
    return false;
  }
}
