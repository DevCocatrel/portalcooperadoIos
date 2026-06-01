import 'dart:convert';

import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/order_details_model.dart';
import 'package:cocatrel/models/orders_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

class MyOrdersRepository {
  static Future<Either<Error, OrdersModel>> loadOrders() async {
    try {
      final response =
          await App.client.get("/loadpagina/cafe/vendasrealizadas");

      if (response.statusCode == 200) {
        return Right(
          OrdersModel.fromJson(response.data),
        );
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<Error, OrderDetailsModel>> loadOrderDetails({
    required String authorizationNumber,
    required String saleNumber,
  }) async {
    try {
      final response = await App.client.get(
        "/cafe/demonstrativoautorizacaovenda",
        queryParameters: {
          "NumVenda": saleNumber,
          "NumAutorizacao": authorizationNumber,
        },
      );

      if (response.statusCode == 200) {
        return Right(OrderDetailsModel.fromJson(response.data));
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<Error, Uint8List>> pdfFileSalesRelationDownload(
    String userName,
  ) async {
    try {
      final response = await App.client.get(
        "/print/cafe/relacaovendas",
        queryParameters: {
          'NomeCooperado': userName,
        },
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          String base64String = response.data.replaceAll('"', '');
          Uint8List decodedBytes = base64Decode(base64String);

          if (lookupMimeType('', headerBytes: decodedBytes) ==
              'application/pdf') {
            return Right(decodedBytes);
          }
        }

        return Left(Error());
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<Error, Uint8List>> pdfFileSaleDetailsDownload({
    required String userName,
    required String saleNumber,
    required String authorizationNumber,
    required String authorizationDate,
    required String saleExpirationDate,
  }) async {
    try {
      final response = await App.client.get(
        "/print/cafe/demonstrativoautorizacaovenda",
        queryParameters: {
          'NomeCooperado': userName,
          'NumVenda': saleNumber,
          'NumAutorizacao': authorizationNumber,
          'DataOperacao': authorizationDate,
          'DataVencimento': saleExpirationDate,
        },
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          String base64String = response.data.replaceAll('"', '');
          Uint8List decodedBytes = base64Decode(base64String);

          if (lookupMimeType('', headerBytes: decodedBytes) ==
              'application/pdf') {
            return Right(decodedBytes);
          }
        }

        return Left(Error());
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<Error, Uint8List>> excelFileSalesRelationDownload(
    String userName,
    String userRegistration,
    String userToken,
  ) async {
    try {
      final response = await Dio().get(
        "https://api-portal.cocatrel.com.br/api/v1/excel/cafe/relacaovendas",
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Authorization': 'Bearer $userToken',
          },
        ),
        queryParameters: {
          'Matricula': userRegistration,
          'NomeCooperado': userName,
        },
      );

      if (response.statusCode == 200) {
        String base64String = response.data.replaceAll('"', '');
        Uint8List decodedBytes = base64Decode(base64String);

        return Right(decodedBytes);
      } else {
        return Left(Error());
      }
    } catch (e) {
      return Left(Error());
    }
  }
}
