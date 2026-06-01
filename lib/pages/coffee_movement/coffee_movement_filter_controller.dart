import 'package:cocatrel/models/coffee_movement_filter_model.dart';
import 'package:cocatrel/models/farm_model.dart';
import 'package:cocatrel/models/option_model.dart';
import 'package:cocatrel/repositories/coffee_balance_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoffeeMovementFilterController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  CoffeeMovementFilterController() {
    fetchFarmList();
  }

  bool loadingFarms = false;
  Either<Error, List<FarmModel>> farms = Right([
    FarmModel(),
    FarmModel(),
  ]);

  Future<void> fetchFarmList() async {
    loadingFarms = true;
    notifyListeners();

    final data = await CoffeeBalanceRepository.getFarms();
    farms = data;

    loadingFarms = false;
    notifyListeners();
  }

  int? currentOptionFarmIndex;

  void changeCurrentOptionFarmIndex(int? value) {
    if (currentOptionFarmIndex != value) {
      currentOptionFarmIndex = value;
      notifyListeners();
    }
  }

  List<OptionModel> get farmOptions => [
        if (farms.isRight)
          ...farms.right.map((item) =>
              OptionModel(item.farm ?? '', item.farmRegistration ?? ''))
      ];

  String get hintFarmOptions {
    if (currentOptionFarmIndex == null) {
      return 'Selecione uma Fazenda';
    }
    return farmOptions[currentOptionFarmIndex!].title ?? '';
  }

  // Movement Type Options
  int? currentOptionMovementTypeIndex;

  void changeCurrentOptionMovementTypeIndex(int? value) {
    if (currentOptionMovementTypeIndex != value) {
      currentOptionMovementTypeIndex = value;
      notifyListeners();
    }
  }

  List<OptionModel> get movementType => [
        OptionModel('Todos', 'T'),
        OptionModel('Entradas', 'E'),
        OptionModel('Saídas', 'S'),
      ];

  String get hintMovementTypeOptions {
    if (currentOptionMovementTypeIndex == null) {
      return 'Tipo de Movimento';
    }
    return movementType[currentOptionMovementTypeIndex!].title ?? '';
  }

  DateTime? startTime;
  void setStartDate(DateTime value) {
    startTime = value;
    notifyListeners();
  }

  String? get statDateFormatted {
    if (startTime != null) {
      return DateFormat('dd/MM/yyyy').format(startTime!);
    }

    return null;
  }

  DateTime? endDate;
  void setEndDate(DateTime value) {
    endDate = value;
    notifyListeners();
  }

  String? get endDateFormatted {
    if (endDate != null) {
      return DateFormat('dd/MM/yyyy').format(endDate!);
    }

    return null;
  }

  CoffeeMovementFilterModel get filter => CoffeeMovementFilterModel(
        farm: farmOptions[currentOptionFarmIndex ?? 0],
        movementType: movementType[currentOptionMovementTypeIndex ?? 0],
        startDate: statDateFormatted ?? '',
        endDate: endDateFormatted ?? '',
      );
}
