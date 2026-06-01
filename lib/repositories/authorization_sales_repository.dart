import 'dart:convert';

import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/authorization_sale_batches_model.dart';
import 'package:cocatrel/models/authorization_sale_model.dart';
import 'package:cocatrel/models/authorization_sale_page_model.dart';
import 'package:either_dart/either.dart';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';

enum AuthorizationFileType {
  pdf,
  excel,
}

class AuthorizationSalesRepository {
  static Future<Either<Error, AuthorizationSaleModel>> loadPage() async {
    try {
      final response = await App.client.get(
        '/loadpagina/cafe/venda',
      );

      if (response.statusCode == 200) {
        return Right(AuthorizationSaleModel.fromJson(response.data));
      }

      return Left(Error());
    } catch (error) {
      return Left(Error());
    }
  }

  static Future<Either<Error, List<AuthorizationSaleBatchesModel>>>
      loadBatchesByInscription(
    String inscription,
  ) async {
    try {
      final response = await App.client.get(
        '/cafe/lotesparavenda',
        queryParameters: {
          'NumInscricao': inscription,
        },
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          final data = (response.data as List)
              .map((json) => AuthorizationSaleBatchesModel.fromJson(json))
              .toList();
          return Right(data);
        }
      }

      return Left(Error());
    } catch (error) {
      return Left(Error());
    }
  }

  static Future<Either<Error, int>> completeSale(dynamic data) async {
    try {
      final response = await App.client.post(
        "/cafe/cria/preautorizacaovenda",
        data: data,
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      }

      return Left(Error());
    } catch (error) {
      return Left(Error());
    }
  }

  static Future<Either<Error, AuthorizationSaleDetailsModel>>
      loadAuthorizationBySaleNumber({
    required String saleNumber,
    required String authorizationNumber,
  }) async {
    try {
      var response = await App.client.get(
        '/cafe/demonstrativoautorizacaovenda',
        queryParameters: {
          'NumVenda': saleNumber,
          'NumAutorizacao': authorizationNumber,
        },
      );

      if (response.statusCode == 200) {
        return Right(AuthorizationSaleDetailsModel.fromJson(response.data));
      }

      return Left(Error());
    } catch (error) {
      return Future.value(Left(Error()));
    }
  }

  static Future<Either<Error, Uint8List>> authorizationReceiptDownload({
    required AuthorizationFileType type,
    required int authorizationNumber,
  }) async {
    try {
      var path = '/print/recibo/autoerizavendacafe';

      if (type == AuthorizationFileType.excel) {
        path = '/excel/recibo/autoerizavendacafe';
      }

      final response = await App.client.get(
        path,
        queryParameters: {
          'NumeroAutorizacao': authorizationNumber,
        },
      );

      if (response.statusCode == 200) {
        if (type == AuthorizationFileType.pdf) {
          if (response.data is String) {
            String base64String = response.data.replaceAll('"', '');
            Uint8List decodedBytes = base64Decode(base64String);

            if (lookupMimeType('', headerBytes: decodedBytes) ==
                'application/pdf') {
              return Right(decodedBytes);
            }
          }
        }

        if (type == AuthorizationFileType.excel) {
          String base64String = response.data.replaceAll('"', '');
          Uint8List decodedBytes = base64Decode(base64String);

          return Right(decodedBytes);
        }

        return Left(Error());
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<Error, Uint8List>> authorizationSaleDownload({
    required AuthorizationFileType type,
    required String cooperateName,
    required String authorizationNumber,
    required String saleNumber,
    required String operationDate,
    required String operationExpirationDate,
  }) async {
    try {
      var path = '/print/cafe/demonstrativoautorizacaovenda';

      if (type == AuthorizationFileType.excel) {
        path = '/excel/cafe/demonstrativoautorizacaovenda';
      }

      final response = await App.client.get(
        path,
        queryParameters: {
          'NomeCooperado': cooperateName,
          'NumVenda': saleNumber,
          'NumAutorizacao': authorizationNumber,
          'DataOperacao': operationDate,
          'DataVencimento': operationExpirationDate,
        },
      );

      if (response.statusCode == 200) {
        if (type == AuthorizationFileType.pdf) {
          if (response.data is String) {
            String base64String = response.data.replaceAll('"', '');
            Uint8List decodedBytes = base64Decode(base64String);

            if (lookupMimeType('', headerBytes: decodedBytes) ==
                'application/pdf') {
              return Right(decodedBytes);
            }
          }
        }

        if (type == AuthorizationFileType.excel) {
          String base64String = response.data.replaceAll('"', '');
          Uint8List decodedBytes = base64Decode(base64String);

          return Right(decodedBytes);
        }

        return Left(Error());
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }
}
