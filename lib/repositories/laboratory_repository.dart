import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/bulletin_model.dart';
import 'package:either_dart/either.dart';

class LaboratoryRepository {
  static Future<Either<Error, List<int>>> getYears() async {
    try {
      final response = await App.client.get('/loadpagina/laboratorio/anos');
      if (response.statusCode == 200 && response.data is Map) {
        if (response.data['Anos'] != null && response.data['Anos'] is List) {
          final data = (response.data['Anos'] as List)
              .map((item) => int.parse('$item'))
              .toList();
          return Right(data);
        }
      }
      return Right(_defaultYears());
    } catch (e) {
      return Right(_defaultYears());
    }
  }

  static Future<Either<Error, List<BulletinModel>>> getBulletinList(
      int year) async {
    try {
      final response = await App.client.get(
        '/listaboletins',
        queryParameters: {'Ano': year},
      );

      if (response.statusCode == 200 && response.data is List) {
        final data = (response.data as List)
            .map((json) => BulletinModel.fromJson(json))
            .toList();
        return Right(data);
      }
      return Left(Error());
    } catch (_) {
      return Left(Error());
    }
  }
}

List<int> _defaultYears() {
  final now = DateTime.now().year;
  var firstYear = 2001;
  final data =
      List.generate((now - firstYear) + 1, (index) => index + firstYear);
  return data;
}
