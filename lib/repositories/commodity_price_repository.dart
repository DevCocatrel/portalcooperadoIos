import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/response_commodity_price_model.dart';
import 'package:either_dart/either.dart';

class CommodityPriceRepository {
  static Future<Either<Exception, ResponseCommodityPriceModel>>
      getResponseCommodityPrice() async {
    try {
      final response =
          await App.client.get('${App.bolsaApiUrl}/bolsa/cotacao/cafe');
      if (response.statusCode == 200 && response.data != null) {
        final data = ResponseCommodityPriceModel.fromJson(response.data);
        return Right(data);
      }
      throw Error();
    } catch (e) {
      return Left(Exception("Falha ao carregar dados de coação"));
    }
  }
}
