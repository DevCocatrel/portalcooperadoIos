import 'package:cocatrel/common/widgets/appbar/profile_app_bar.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/drawers/basic_menu_drawer.dart';
import 'package:cocatrel/core/app/app_config.dart';
import 'package:cocatrel/pages/services/widgets/card_widget.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      drawer: const BasicMenuDrawer(),
      appBar: const ProfileAppBar(
        title: 'Serviços Cocatrel',
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            SizedBox(height: 16),
            Text('Serviços'),
            SizedBox(height: 16),
            CardWidget(
              icon: Icons.schedule,
              linkPDF: AppConfig.warehouseOpeningHoursLink,
              title: 'Horário dos armazéns',
            ),
            SizedBox(height: 16),
            CardWidget(
              icon: Icons.article_outlined,
              linkPDF: AppConfig.serviceTableLink,
              title: 'Tabela de serviços',
            ),
            SizedBox(height: 16),
            CardWidget(
              icon: Icons.grain_rounded,
              linkPDF: AppConfig.coffeePatternsLink,
              title: 'Padrões de café Cocatrel',
            ),
          ],
        ),
      ),
    );
  }
}
