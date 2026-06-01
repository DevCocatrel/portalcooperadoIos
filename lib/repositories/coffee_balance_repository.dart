import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/farm_model.dart';
import 'package:cocatrel/models/coffee_extract_from_farm_model.dart';
import 'package:either_dart/either.dart';

class CoffeeBalanceRepository {
  static Future<Either<Error, List<FarmModel>>> getFarms() async {
    try {
      final response = await App.client.get('/loadpagina/cafe/saldo');
      if (response.statusCode == 200) {
        if (response.data is List) {
          final data = (response.data as List)
              .map((json) => FarmModel.fromJson(json))
              .toList();
          return Right(data);
        }
      }
      return Left(Error());
    } catch (_) {
      return Left(Error());
    }
  }

  static Future<Either<Error, CoffeeExtractFromFarmModel>>
      getCoffeeExtractFromFarm(String farmRegistration) async {
    try {
      final response =
          await App.client.get('/cafe/disponivel/extrato', queryParameters: {
        'InscricaoFazenda': farmRegistration,
      });
      if (response.statusCode == 200) {
        if (response.data is Map) {
          final data = CoffeeExtractFromFarmModel.fromJson(response.data);
          return Right(data);
        }
      }
      return Left(Error());
    } catch (_) {
      return Left(Error());
    }
  }
}
