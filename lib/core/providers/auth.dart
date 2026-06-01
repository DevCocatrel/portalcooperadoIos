import 'dart:async';
import 'dart:convert';

import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/models/user_model.dart';
import 'package:cocatrel/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider of(BuildContext context) => context.read<AuthProvider>();

  final int differenceInMinutes = 2;
  static SharedPreferences? prefs;
  UserModel? user;

  Future<void> initializeWithSplash() async {
    prefs ??= await SharedPreferences.getInstance();
    user = getFromPrefs();

    _setHeaders(user);

    _startTokenTimer();

    if (user != null) {
      if (_tokenIsExpired() || _isTokenExpiringSoon()) {
        await refreshToken();
      }
    }
  }

  String get initialRoute {
    if (App.hasInternet ?? true) {
      return user != null ? AppRoutes.home : AppRoutes.login;
    }
    return AppRoutes.withoutNetwork;
  }

  void _startTokenTimer() {
    Future.delayed(const Duration(minutes: 1), () {
      if (user != null) {
        checkTokenExpiration().then((_) {
          _startTokenTimer();
        });
      } else {
        _startTokenTimer();
      }
    });
  }

  Future<void> checkTokenExpiration() async {
    if (user == null) return;
    if (_isTokenExpiringSoon()) {
      await refreshToken();
    }
  }

  bool _tokenIsExpired() {
    return JwtDecoder.isExpired(user!.token!);
  }

  bool _isTokenExpiringSoon() {
    DateTime expirationDate = JwtDecoder.getExpirationDate(user!.token!);
    Duration difference = expirationDate.difference(DateTime.now());

    return difference.inMinutes < differenceInMinutes;
  }

  Future<void> refreshToken() async {
    if (user?.isAdmin ?? false) {
      return;
    }
    final response = await LoginRepository.refreshToken(user!.refreshToken!);

    if (response.isLeft) {
      return;
    }

    if (response.isRight) {
      final data = response.right;

      setNewToken(data.token, data.refreshToken);
    }
  }

  UserModel? getFromPrefs() {
    final userString = prefs!.getString('user');

    if (userString != null) {
      try {
        final Map<String, dynamic> userMap = json.decode(userString);
        return UserModel.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  setUser(UserModel? userData) {
    saveInPrefs(userData);
  }

  setNewToken(String token, String refreshToken) {
    final user = getFromPrefs();

    if (user != null) {
      user.token = token;
      user.refreshToken = refreshToken;
      saveInPrefs(user);
    }
  }

  saveInPrefs(UserModel? userData) {
    user = userData;
    notifyListeners();

    if (userData != null) {
      var encode = json.encode(userData.toJson());
      prefs!.setString('user', encode);

      App.client.options.headers = {
        ...App.client.options.headers,
        'Authorization': 'Bearer ${userData.token}',
      };

      App.client.options.queryParameters = {
        'Matricula': userData.registration,
        'NomeCooperado': userData.name ?? '',
      };
    } else {
      prefs!.remove('user');

      App.client.options.headers = {
        ...App.client.options.headers,
        'Authorization': '',
      };

      App.client.options.queryParameters = {};
    }
  }

  void logout() {
    saveInPrefs(null);
  }

  _setHeaders(UserModel? user) {
    if (user != null) {
      App.client.options.headers = {
        ...App.client.options.headers,
        'Authorization': 'Bearer ${user.token}',
      };

      App.client.options.queryParameters = {
        'Matricula': user.registration,
      };
    }

    notifyListeners();
  }
}
