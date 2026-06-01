import 'package:cocatrel/models/option_model.dart';

class CoffeeMovementFilterModel {
  OptionModel farm;
  OptionModel movementType;
  String startDate;
  String endDate;

  CoffeeMovementFilterModel({
    required this.farm,
    required this.movementType,
    required this.startDate,
    required this.endDate,
  });

  Map<String, String> get toMap {
    return {
      'InscricaoFazenda': farm.value ?? '',
      'Fazenda': farm.title ?? '',
      'TpMovimento': movementType.value ?? '',
      'DataInicio': startDate,
      'DataFim': endDate,
    };
  }
}
