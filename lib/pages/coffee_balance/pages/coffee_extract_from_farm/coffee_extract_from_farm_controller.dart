import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/models/coffee_extract_from_farm_model.dart';
import 'package:cocatrel/models/farm_model.dart';
import 'package:cocatrel/models/lot_model.dart';
import 'package:cocatrel/repositories/coffee_balance_repository.dart';
import 'package:cocatrel/repositories/file_download_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class CoffeeExtractFromFarmController extends ChangeNotifier {
  CoffeeExtractFromFarmController(String farmRegistration) {
    fetchCoffeeExtract(farmRegistration);
  }
  bool loading = false;

  Either<Error, CoffeeExtractFromFarmModel> coffeeExtract = Right(
    CoffeeExtractFromFarmModel(
      lotList: [
        LotModel.empty(),
        LotModel.empty(),
      ],
    ),
  );

  Future<void> fetchCoffeeExtract(String farmRegistration) async {
    loading = true;
    notifyListeners();

    final data = await CoffeeBalanceRepository.getCoffeeExtractFromFarm(
        farmRegistration);

    coffeeExtract = data;

    loading = false;
    notifyListeners();
  }

  bool loadingDownloadFile = false;

  void downloadFile(FarmModel farm, String fileType) async {
    if (loadingDownloadFile) return;

    loadingDownloadFile = true;
    notifyListeners();

    final path = fileType == 'pdf'
        ? '/print/cafe/extratomovimentacao'
        : '/excel/cafe/extratomovimentacao';

    final file = await FileDownloadRepository.downloadFileAsBase64(
      path,
      {
        'InscricaoFazenda': farm.farmRegistration ?? '',
        'NomeFazenda': farm.farm ?? '',
      },
      'extrato_cafe_${farm.farm}',
    );

    if (file.isRight) {
      successSnackBar('Arquivo salvo com sucesso');
    }

    loadingDownloadFile = false;
    notifyListeners();
  }
}
