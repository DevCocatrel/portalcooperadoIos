import 'dart:convert';
import 'dart:io';

import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/utils/is_pdf.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

class FileDownloadRepository {
  static Future<Uint8List?> downloadFileAsBinary(String url) async {
    try {
      Response response = await Dio().get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      if (response.data is Uint8List) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Either<Error, File>> downloadFileAsBase64(
    String path,
    Map<String, String> params,
    String? name, {
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await App.client.get(
        path,
        queryParameters: params,
        onReceiveProgress: onReceiveProgress,
      );

      Uint8List bytes = base64.decode(response.data);

      name ??= DateTime.now().millisecondsSinceEpoch.toString();

      final isPDF = isPdf(bytes);

      name = name.toLowerCase().replaceAll(' ', '_');

      final filePath = await FileSaver.instance.saveAs(
        name: name,
        bytes: bytes,
        mimeType: isPDF ? MimeType.pdf : MimeType.microsoftExcel,
        fileExtension: isPDF ? "pdf" : 'xlsx',
      );
      if (filePath != null) {
        return Right(File(filePath));
      } else {
        errorSnackBar('O arquivo não foi salvo');
        return Left(Error());
      }
    } catch (_) {
      errorSnackBar('Erro ao baixar o arquivo');
      return Left(Error());
    }
  }
}

class ProgressController extends ChangeNotifier {
  int? count = 0;
  int? total = 1;

  setValues(int? value, int? value2) {
    count = value;
    total = value2;

    notifyListeners();
  }

  double get percentage {
    return (count ?? .0) / (total ?? 1);
  }
}
