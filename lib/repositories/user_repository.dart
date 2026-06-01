import 'package:cocatrel/core/app/app.dart';

class UserRepository {
  static Future<bool> changePassword(
      {required String newPassword,
      required String confirmPassword,
      required String registration}) async {
    try {
      final response = await App.client.post('/trocasenha', data: {
        "Matricula": registration,
        "NovaSenha": newPassword,
        "RNovaSenha": confirmPassword
      });

      return (response.statusCode ?? 0) < 300 &&
          (response.statusCode ?? 0) >= 200;
    } catch (e) {
      return false;
    }
  }
}
