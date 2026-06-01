import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/app/app_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchWhatsApp(BuildContext context, {String? content}) async {
  var toLaunch = Uri(
    scheme: "https",
    host: "wa.me",
    path: "/${AppConfig.companyPhone}",
    queryParameters: {
      "text": content ?? "Olá, gostaria de falar com você",
    },
  );

  try {
    await launchUrl(toLaunch);
  } catch (e) {
    if (context.mounted) {
      errorSnackBar("Não foi possível abrir o WhatsApp");
    }
  }
}
