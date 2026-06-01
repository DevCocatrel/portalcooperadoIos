import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/bonds_payable_model.dart';
import 'package:either_dart/either.dart';

class BondsPayableRepository {
  static Future<Either<Error, BondsPayableModel>> getBondsPayableList() async {
    try {
      final response =
          await App.client.get('/loadpagina/cooperado/titulosaberto');

      if (response.statusCode == 200 && response.data is Map) {
        final data = BondsPayableModel.fromJson(response.data);
        return Right(data);
      }
      return Left(Error());
    } catch (e) {
      return Left(Error());
    }
  }
}
