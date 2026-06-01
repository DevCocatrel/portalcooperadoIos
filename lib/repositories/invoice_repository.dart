import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/invoice_model.dart';
import 'package:either_dart/either.dart';

class InvoiceRepository {
  static Future<Either<Error, InvoiceList>> getInvoices() async {
    try {
      final response = await App.client.get('/loadpagina/cooperado/boletos');

      if (response.statusCode == 200 && response.data is Map) {
        final data = InvoiceList.fromJson(response.data);

        return Right(data);
      }
      return Left(Error());
    } catch (_) {
      return Left(Error());
    }
  }
}
