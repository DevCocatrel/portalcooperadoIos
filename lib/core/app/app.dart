import 'package:app_version_update/app_version_update.dart';
import 'package:cocatrel/common/widgets/bottom_sheet/update_version_bottom_sheet.dart';
import 'package:cocatrel/core/app/app_routes.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class App {
  static const bolsaApiUrl = 'https://api-portal.cocatrel.com.br/api/v1';
  static final client = Dio(
    BaseOptions(
      baseUrl: 'https://api-portal.cocatrel.com.br/v1',
      contentType: Headers.jsonContentType,
    ),
  )..interceptors.add(
      InterceptorsWrapper(onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          final authProvider = AuthProvider.of(navigatorKey.currentContext!);
          if (authProvider.user?.isAdmin ?? false) {
            if (!error.requestOptions.path.contains('auth')) {
              final currentRoute = routeObserver.currentRoute;
              if (currentRoute != AppRoutes.sessionExpired) {
                Navigator.pushReplacementNamed(
                  navigatorKey.currentContext!,
                  AppRoutes.sessionExpired,
                );
                AuthProvider.of(navigatorKey.currentContext!).setUser(null);
              }
            }
          } else if (authProvider.user != null) {
            authProvider.refreshToken();
          }
        }
        handler.next(error);
      }),
    );

  static MyRouteObserver routeObserver = MyRouteObserver();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static String? deviceModel;

  static bool? hasInternet;

  static Future<void> setInternetStatus() async {
    hasInternet = (await InternetConnection.createInstance().internetStatus) ==
        InternetStatus.connected;
  }

  static Future<void> getDeviceInfo() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    if (deviceInfo is AndroidDeviceInfo) {
      deviceModel = (deviceInfo).model;
    } else if (deviceInfo is IosDeviceInfo) {
      deviceModel = (deviceInfo).model;
    }
  }

  static Future<void> checkVersionUpdate() async {
    const appleId = '6740828537';
    await AppVersionUpdate.checkForUpdates(
            appleId: appleId, playStoreId: 'com.cocatrel.cooperado')
        .then((data) async {
      if (data.canUpdate!) {
        showModalBottomSheet(
          context: navigatorKey.currentContext!,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (context) => UpdateVersionBottomSheet(
            storeUrl: data.storeUrl ?? '',
          ),
        );
      }
    });
  }
}
