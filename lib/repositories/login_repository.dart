import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/refresh_token_model.dart';
import 'package:cocatrel/models/user_model.dart';
import 'package:either_dart/either.dart';

class LoginRepository {
  static Future<UserModel?> loginAsAdmin({
    required String registration,
    required String userName,
    required String password,
  }) async {
    try {
      final response = await App.client.post(
        '/auth/tokenadm',
        data: {
          "Matricula": registration,
          "Usuario": userName,
          "Senha": password,
          "Sistema": App.deviceModel,
        },
      );
      if (response.statusCode == 200) {
        if (response.data != null && response.data['Token'] != null) {
          final userModel =
              UserModel.fromJson({...response.data, 'isAdmin': true});
          return userModel;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<UserModel?> login(String registration, String password) async {
    try {
      final response = await App.client.post('/auth/token', data: {
        "Matricula": registration,
        "Senha": password,
        "Sistema": App.deviceModel,
      });
      if (response.statusCode == 200) {
        if (response.data != null && response.data['Token'] != null) {
          return UserModel.fromJson(response.data);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<Either<Error, RefreshTokenModel>> refreshToken(
      String refreshToken) async {
    try {
      final response = await App.client.post(
        '/auth/tokenrefresh',
        queryParameters: {
          'TokenRefresh': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        return Right(RefreshTokenModel.fromJson(response.data));
      }

      return Left(Error());
    } catch (_) {
      return Left(Error());
    }
  }
}
