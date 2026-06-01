import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/ombudsman_options_model.dart';

class OmbudsmanRepository {
  static Future<OmbudsmanOptionsModel?> getOmbudsmanOptions() async {
    try {
      final response = await App.client.get('/load/ouvidoria');
      if (response.statusCode == 200 && response.data is Map) {
        return OmbudsmanOptionsModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> sendMessage({
    required String registration,
    required String type,
    required String message,
    required String phone,
    required String name,
    required String department,
    required bool confirmReturns,
  }) async {
    try {
      final response = await App.client.post('/ouvidoria', data: {
        "Matricula": registration,
        "TIPO_SAC": type,
        "MENSAGEM_SAC": message,
        "TELEFONE_CONTATO": phone,
        "SISTEMA": App.deviceModel,
        "NOME_CONTATO": name,
        "ID_SAC_DEPARTAMENTO": department,
        "RETORNO_SAC": confirmReturns ? "1" : "0"
      });

      return (response.statusCode ?? 0) < 300 &&
          (response.statusCode ?? 0) >= 200;
    } catch (_) {
      return false;
    }
  }
}
