import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/models/bulletin_model.dart';
import 'package:cocatrel/repositories/file_download_repository.dart';
import 'package:cocatrel/repositories/laboratory_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class LaboratoryController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  LaboratoryController() {
    fetchYear();
  }

  bool loading = false;
  Either<Error, List<int>> years = const Right([]);

  int? currentYear;
  void changeCurrentYear(int? value) {
    currentYear = value;
    notifyListeners();
  }

  Future<void> fetchYear() async {
    loading = true;
    notifyListeners();

    years = await LaboratoryRepository.getYears();

    loading = false;
    notifyListeners();
  }

  bool loadingBulletinList = false;
  Either<Error, List<BulletinModel>> bulletinList = const Right([]);
  Future<void> fetchBulletinList() async {
    if (loading) return;
    if (!formKey.currentState!.validate()) return;

    loadingBulletinList = true;
    if (bulletinList.isLeft || bulletinList.right.isEmpty) {
      bulletinList = Right([BulletinModel()]);
    }

    notifyListeners();

    bulletinList = await LaboratoryRepository.getBulletinList(currentYear ?? 0);

    loadingBulletinList = false;
    notifyListeners();
  }

  String loadingDownloadBulletin = '';
  Future<void> downloadFile(
      String bulletinCode, String bulletinType, String model,
      {void Function(int, int)? onReceiveProgress}) async {
    loadingDownloadBulletin = bulletinCode;
    notifyListeners();

    final file = await FileDownloadRepository.downloadFileAsBase64(
        '/$model/laboratorio/boletim',
        {
          'Ano': '${currentYear ?? 0}',
          'NumBoletim': bulletinCode,
          'TipoAnalise': bulletinType
        },
        'boletim_$bulletinCode',
        onReceiveProgress: onReceiveProgress);

    if (file.isLeft) {
      errorSnackBar('Erro ao salvar arquivo');
    } else {
      successSnackBar('Arquivo salvo com sucesso');
    }

    loadingDownloadBulletin = '';
    notifyListeners();
  }
}
