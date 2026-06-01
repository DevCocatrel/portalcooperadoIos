import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/models/coffee_movement_filter_model.dart';
import 'package:cocatrel/models/extract_movement_model.dart';
import 'package:cocatrel/repositories/coffee_movement_repository.dart';
import 'package:cocatrel/repositories/file_download_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class CoffeeMovementController extends ChangeNotifier {
  CoffeeMovementController(this.filter) {
    fetchExtractMovement();
  }
  final CoffeeMovementFilterModel filter;

  bool loading = false;
  Either<Error, ExtractMovement> extractMovement =
      Right(ExtractMovement(movementsList: [
    Movement(),
    Movement(),
  ]));

  Future<void> fetchExtractMovement() async {
    loading = true;
    notifyListeners();

    extractMovement =
        await CoffeeMovementRepository.getExtractMovement(filter.toMap);

    loading = false;
    notifyListeners();
  }

  bool loadingDownload = false;
  Future<void> downloadFile(String model) async {
    if (loadingDownload) return;
    loadingDownload = true;
    notifyListeners();

    String fileName =
        'extrato_movimentacao_${filter.farm.title}_${filter.movementType.title}_${filter.startDate}-${filter.endDate}';
    fileName = fileName.replaceAll(' ', '_');
    fileName = fileName.replaceAll('/', '_');
    fileName = fileName.toLowerCase();
    final file = await FileDownloadRepository.downloadFileAsBase64(
      '/$model/cafe/extratomovimentacao/analitico',
      filter.toMap,
      fileName,
    );

    if (file.isLeft) {
      errorSnackBar('Erro ao baixar o arquivo');
    } else {
      successSnackBar('Arquivo salvo com sucesso');
    }

    loadingDownload = false;
    notifyListeners();
  }
}
