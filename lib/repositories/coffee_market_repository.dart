import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/coffee_history_model.dart';
import 'package:cocatrel/models/coffee_market_page_model.dart';
import 'package:either_dart/either.dart';

class CoffeeMarketRepository {
  static Future<Either<Error, CoffeeMarketPageModel>> loadPage() async {
    try {
      final response = await App.client.get("/loadpagina/cafe/mercado");

      if (response.statusCode == 200) {
        return Right(CoffeeMarketPageModel.fromJson(response.data));
      }
      return Left(Error());
    } catch (error) {
      return Left(Error());
    }
  }

  static Future<Either<Error, List<CoffeeHistoryModel>>> loadHistoryOfQuote(
    String quote,
  ) async {
    try {
      final response = await App.client.get(
        "/cafe/mercado/evolucaopreco",
        queryParameters: {
          "COC": quote,
        },
      );

      if (response.statusCode == 200) {
        return Right(
          (response.data as List)
              .map(
                (json) => CoffeeHistoryModel.fromJson(json),
              )
              .toList(),
        );
      }

      return Left(Error());
    } catch (error) {
      return Left(Error());
    }
  }

  static Future<Either<Error, CoffeeMarketPageModel>> loadPageByDate(
    String date,
  ) async {
    try {
      final response = await App.client.get(
        "/cafe/mercado/dia",
        queryParameters: {
          "DataCotacao": date,
        },
      );

      if (response.statusCode == 200) {
        return Right(CoffeeMarketPageModel.fromJson(response.data));
      }
      return Left(Error());
    } catch (error) {
      return Left(Error());
    }
  }
}
