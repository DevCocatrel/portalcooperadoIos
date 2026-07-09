import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/coffee_entry_model.dart';
import 'package:cocatrel/models/deposit_farm_list_model.dart';
import 'package:cocatrel/models/last_invoice_list.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'dart:convert'; // Importe para o base64Decode
import 'dart:typed_data'; // Importe para o Uint8List

class DepositSlipRepository {
  static Future<Either<Error, DepositFarmListModel>>
      getDepositFarmList() async {
    try {
      final response =
          await App.client.get('/loadpagina/cafe/deposito/listafazendas');
      if (response.statusCode == 200 && response.data is Map) {
        final data = DepositFarmListModel.fromJson(response.data);

        return Right(data);
      }
      return Left(Error());
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<Error, CoffeeEntryModel>> getCoffeeEntryModel(
      String farmRegistration) async {
    try {
      final response =
          await App.client.get('/loadmodal/cafe/entradas', queryParameters: {
        'InscricaoFazenda': farmRegistration,
      });
      if (response.statusCode == 200 && response.data is Map) {
        final data = CoffeeEntryModel.fromJson(response.data);
        return Right(data);
      }
      return Left(Error());
    } catch (_) {
      return Left(Error());
    }
  }

  static Future<Either<Error, LastInvoiceList>> getListInvoiceList() async {
    try {
      final response =
          await App.client.get('/loadpagina/cafe/deposito/ultimasnfe');

      if (response.statusCode == 200 && response.data is Map) {
        final data = LastInvoiceList.fromJson(response.data);
        return Right(data);
      }

      return Left(Error());
    } catch (_) {
      return Left(Error());
    }
  }

  static Future<Either<Error, List<String>>> getTractorList() async {
    try {
      final response = await App.client.get('/guiadeposito/listatratores');
      if (response.statusCode == 200 && response.data is Map) {
        if (response.data['Tratores'] is List) {
          final data = (response.data['Tratores'] as List)
              .map((item) => item['NomeTrato'] as String)
              .toList();
          return Right(data);
        }
      }
      return Left(Error());
    } catch (e) {
      return Left(Error());
    }
  }

  static Future<Either<String, bool>> issueInvoice(
      DepositSlip depositSlip) async {
    try {
      final response = await App.client.post(
        '/cafe/geranfeentrada',
        data: depositSlip.toJson,
      );

      if (response.statusCode == 200) {
        return const Right(true);
      }

      return const Right(false);
    } on DioException catch (dioError) {
      if (dioError.response?.data != null) {
        if (dioError.response!.data is String) {
          return Left(dioError.response!.data as String);
        }
      }

      return const Right(false);
    } catch (e) {
      return const Right(false);
    }
  }

  static Future<Either<String, Uint8List>> issueInvoiceAndGetPdf(
      DepositSlip depositSlip) async {
    try {
      final response = await App.client.post(
        '/cafe/geranfeentrada',
        data: depositSlip.toJson,
      );

      if (response.statusCode == 200 && response.data is String) {
        // Converte o Base64 retornado em bytes
        final Uint8List pdfBytes = base64Decode(response.data as String);
        return Right(pdfBytes);
      }

      return const Left("Erro ao gerar PDF: Formato inesperado");
    } on DioException catch (dioError) {
      if (dioError.response?.data is String) {
        return Left(dioError.response!.data as String);
      }
      return const Left("Erro ao processar emissão");
    } catch (e) {
      return const Left("Erro desconhecido");
    }
  }
}
