import 'package:cocatrel/models/bonds_payable_model.dart';
import 'package:cocatrel/repositories/bonds_payable_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class BondsPayableController extends ChangeNotifier {
  BondsPayableController() {
    fetchBondPayableList();
  }
  bool loading = false;
  Either<Error, BondsPayableModel> bondsPayable = Right(
    BondsPayableModel(
      totalBondsPayable: .0,
      bondPayableList: [
        BondPayableModel(),
      ],
    ),
  );

  Future<void> fetchBondPayableList() async {
    loading = true;
    notifyListeners();

    bondsPayable = await BondsPayableRepository.getBondsPayableList();

    loading = false;
    notifyListeners();
  }
}
