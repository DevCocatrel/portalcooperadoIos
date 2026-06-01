import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:flutter/material.dart';

class CoffeeInformationController extends ChangeNotifier {
  CoffeeInformationController(this.depositSlip);
  DepositSlip depositSlip;

  final formKey = GlobalKey<FormState>();

  final quantityBagsTextController = TextEditingController();
  final quantityKgs = TextEditingController();

  bool validate(DepositSlip deposit) {
    if (formKey.currentState!.validate()) {
      depositSlip.quantityBags = double.parse(
          (num.tryParse(quantityBagsTextController.text) ?? 0)
              .toDouble()
              .toStringAsFixed(2));
      depositSlip.quantityKgs = double.parse(
          (num.tryParse(quantityKgs.text) ?? 0).toDouble().toStringAsFixed(2));

      depositSlip.totalValue = total;

      return true;
    }

    return false;
  }

  double get total {
    final valueNum = double.parse(
        (num.tryParse(quantityBagsTextController.text) ?? 0)
            .toDouble()
            .toStringAsFixed(2));

    return valueNum * (depositSlip.coffeePrice ?? 1);
  }

  void changeTypeCoffee(TypeCoffee value) {
    depositSlip.typeCoffee = value;
    if (value == TypeCoffee.passOrChoose) {
      depositSlip.dryProcess = DryProcess.normal;
      depositSlip.personalized = false;
    }
    notifyListeners();
  }

  void changeDryProcess(DryProcess value) {
    if (depositSlip.typeCoffee == TypeCoffee.coffee) {
      depositSlip.dryProcess = value;
      if (value == DryProcess.peeledCherry) {
        depositSlip.personalized = true;
      }
      notifyListeners();
    }
  }

  void changePersonalized(bool value) {
    if (depositSlip.typeCoffee == TypeCoffee.coffee &&
        depositSlip.dryProcess == DryProcess.normal) {
      depositSlip.personalized = value;
      notifyListeners();
    }
  }

  void onChangeQuantityBags() {
    final valueNum = double.parse(
        (num.tryParse(quantityBagsTextController.text) ?? 0)
            .toDouble()
            .toStringAsFixed(2));

    final valueKgs =
        double.parse((valueNum > 0 ? valueNum * 60 : 0).toStringAsFixed(2));

    final quantityKgsNum = (num.tryParse(quantityKgs.text) ?? 0).toDouble();

    if (quantityKgsNum != valueKgs) {
      quantityKgs.text = '$valueKgs';
    }
  }

  void onEditingComplete() {
    notifyListeners();
  }
}
