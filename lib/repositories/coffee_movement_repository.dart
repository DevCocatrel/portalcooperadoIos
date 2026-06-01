import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/extract_movement_model.dart';
import 'package:either_dart/either.dart';

class CoffeeMovementRepository {
  static Future<Either<Error, ExtractMovement>> getExtractMovement(
      Map<String, String> params) async {
    try {
      final response = await App.client
          .get('/cafe/extrato/movimentacao', queryParameters: params);
      if (response.statusCode == 200 && response.data is Map) {
        final data = ExtractMovement.fromJson(response.data);
        return Right(data);
      }
      throw Error();
    } catch (_) {
      return Left(Error());
    }
  }
}
