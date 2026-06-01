import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:flutter/material.dart';

void errorSnackBar(String message) {
  final context = App.navigatorKey.currentContext!;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.danger,
      content: Text(
        message,
      ),
    ),
  );
}

void successSnackBar(String message, {SnackBarAction? action, int? seconds}) {
  final context = App.navigatorKey.currentContext!;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: action,
      showCloseIcon: false,
      duration: Duration(seconds: seconds ?? 3),
    ),
  );
}
