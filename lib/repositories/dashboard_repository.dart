import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/dashboard_data.dart';
import 'package:cocatrel/models/dashboard_commodities.dart';
import 'package:cocatrel/models/dashboard_quotes.dart';
import 'package:either_dart/either.dart';

class DashboardRepository {
  static Future<Either<Error, DashboardCommodities>> loadCommodities() async {
    try {
      final response = await App.client.get("/bolsa/cotacao");

      if (response.statusCode == 200) {
        return Right(DashboardCommodities.fromJson(response.data));
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<Error, DashboardQuotes>> loadQuotes() async {
    try {
      final response = await App.client.get(
        "/loadpagina/cafe/mercado_principais",
      );

      if (response.statusCode == 200) {
        return Right(DashboardQuotes.fromJson(response.data));
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<Error, DashboardData>> loadPage() async {
    try {
      final response = await App.client.get(
        "/loadPagina/dashboard",
      );

      if (response.statusCode == 200) {
        return Right(DashboardData.fromJson(response.data));
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }
}
