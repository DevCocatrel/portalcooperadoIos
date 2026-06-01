import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/models/farm_model.dart';
import 'package:cocatrel/repositories/coffee_balance_repository.dart';
import 'package:cocatrel/repositories/file_download_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeBalanceController extends ChangeNotifier {
  CoffeeBalanceController() {
    fetchCoffeeBalance();
  }

  bool loading = false;

  Either<Error, List<FarmModel>> farms = Right([
    FarmModel.empty(),
  ]);

  Future<void> fetchCoffeeBalance() async {
    loading = true;
    notifyListeners();

    farms = await CoffeeBalanceRepository.getFarms();

    loading = false;
    notifyListeners();
  }

  bool loadingDownloadFile = false;

  void downloadFile() async {
    if (loadingDownloadFile) return;

    loadingDownloadFile = true;
    notifyListeners();

    final file = await FileDownloadRepository.downloadFileAsBase64(
      '/print/cafe/saldo',
      {
        'NomeCooperado':
            App.navigatorKey.currentContext!.read<AuthProvider>().user?.name ??
                ''
      },
      'relacao_cafe',
    );

    if (file.isRight) {
      successSnackBar('Arquivo salvo com sucesso', seconds: 5);
    }

    loadingDownloadFile = false;
    notifyListeners();
  }
}
