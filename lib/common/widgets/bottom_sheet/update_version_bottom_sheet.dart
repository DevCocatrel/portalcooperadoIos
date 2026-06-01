import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateVersionBottomSheet extends StatelessWidget {
  const UpdateVersionBottomSheet({
    required this.storeUrl,
    super.key,
  });

  final String storeUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Uma nova versão do aplicativo está disponível!',
            style: TextStyle(fontSize: 18),
          ),
          const Text(
            'Por favor, atualize para a versão mais recente para usar todos os recursos.',
            style: TextStyle(fontSize: 14),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Continuar",
                    style: AppFonts.textButton.copyWith(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    launchUrlString(storeUrl,
                        mode: LaunchMode.externalApplication);
                  },
                  child: const Text('Atualizar'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
