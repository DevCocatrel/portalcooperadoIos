import 'package:cocatrel/common/widgets/appbar/go_back_app_bar.dart';
import 'package:cocatrel/common/widgets/cards/default_card_widget.dart';
import 'package:cocatrel/common/widgets/default_scaffold/default_scaffold_widget.dart';
import 'package:cocatrel/common/widgets/divider/divider_widget.dart';
import 'package:cocatrel/core/app/app_colors.dart';
import 'package:cocatrel/core/styles/app_fonts.dart';
import 'package:cocatrel/core/utils/currency.dart';
import 'package:cocatrel/core/utils/brazilian_format_double.dart';
import 'package:cocatrel/models/farm_model.dart';
import 'package:cocatrel/models/lot_model.dart';
import 'package:cocatrel/pages/coffee_balance/widgets/row_with_data_widget.dart';
import 'package:flutter/material.dart';

class LotDetailsPage extends StatelessWidget {
  const LotDetailsPage(this.lotDetails, this.coffeeBalance, {super.key});

  final LotModel lotDetails;
  final FarmModel coffeeBalance;

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      appBar: const GoBackAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16).copyWith(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleCard('Lote ${lotDetails.lotNumber}'),
              cardWithInformationWidget(
                _farmTitleWidget(),
                [
                  KeyValue('Inscrição', coffeeBalance.farmRegistration ?? ''),
                  KeyValue('Nota fiscal', lotDetails.invoiceNumber ?? ''),
                  KeyValue('Data entrada',
                      (lotDetails.entryDateFormatted ?? '').toString())
                ],
              ),
              _titleCard('Detalhes do lote'),
              cardWithInformationWidget(
                _simpleTitle('Rastreabilidade'),
                [
                  KeyValue('Nota fiscal', lotDetails.invoiceNumber ?? ''),
                  KeyValue('Certificações', lotDetails.certifier ?? ''),
                  KeyValue('Lote', lotDetails.lotNumber ?? '')
                ],
              ),
              const SizedBox(height: 16),
              cardWithInformationWidget(
                _simpleTitle('Volume de sacas 60kg'),
                [
                  KeyValue('Sacas entrada',
                      brazilianFormatDouble(lotDetails.quantityReceived ?? .0)),
                  KeyValue('Sacas saldo',
                      brazilianFormatDouble(lotDetails.balanceBags ?? .0)),
                  KeyValue('Sacas bloqueadas',
                      brazilianFormatDouble(lotDetails.blockedQuantity ?? .0)),
                  KeyValue(
                    'Sacas autorizadas',
                    Currency.format(lotDetails.authorizedQuantity ?? .0),
                  ),
                  KeyValue(
                    'Sacas disponíveis',
                    brazilianFormatDouble(lotDetails.availableQuantity ?? .0),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              cardWithInformationWidget(
                Row(
                  children: [
                    Expanded(child: _simpleTitle('Quantidade')),
                    Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: lotDetails.backgroundColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(lotDetails.standardName ?? ''),
                  ],
                ),
                [
                  KeyValue('Padrão', lotDetails.standardName ?? ''),
                  KeyValue('Catação (%)',
                      (lotDetails.breakagePercentage ?? .0).toInt().toString()),
                  KeyValue('Peneira', lotDetails.favoriteName ?? ''),
                  KeyValue('Seca (%)', lotDetails.dryingName ?? ''),
                  KeyValue(
                      'Pontos', brazilianFormatDouble(lotDetails.score ?? .0)),
                ],
              ),
              const SizedBox(height: 16),
              cardWithInformationWidget(
                const Text('Valores simulados (R\$)'),
                [
                  KeyValue(
                    'Valor unitário bruto (R\$)',
                    Currency.basicFormat(lotDetails.grossUnitValue ?? .0),
                  ),
                  KeyValue(
                    'ICMS 1% (+)',
                    Currency.basicFormat(lotDetails.icmsValue ?? .0),
                  ),
                  KeyValue(
                    'Armazenagem seguro carga descarga (-)',
                    Currency.basicFormat(lotDetails.expensesValue ?? .0),
                  ),
                  KeyValue(
                    'Personalizado (R\$ 0,022 ao dia) (-)',
                    Currency.basicFormat(lotDetails.customizedValue ?? .0),
                  ),
                  KeyValue(
                    'INSS 1,5% (-)',
                    Currency.basicFormat(lotDetails.inssValue ?? .0),
                  ),
                  KeyValue(
                    'Capital 0,5% (-)',
                    Currency.basicFormat(
                        lotDetails.capitalRetentionValue ?? .0),
                  ),
                  KeyValue(
                    'Valor Unit. Líquido (R\$)',
                    Currency.basicFormat(lotDetails.netUnitValue ?? .0),
                  ),
                  KeyValue(
                    'Total Líquido (R\$)',
                    Currency.basicFormat(lotDetails.netValue ?? .0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleTitle(String title) {
    return Text(title);
  }

  Widget _titleCard(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(title),
    );
  }

  Row _farmTitleWidget() {
    return Row(
      children: [
        const Icon(
          Icons.agriculture_outlined,
          color: AppColors.primaryDark,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            coffeeBalance.farm ?? '',
            style: AppFonts.title.copyWith(
              fontSize: 14,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }

  DefaultCardWidget cardWithInformationWidget(
      Widget title, List<KeyValue> values) {
    return DefaultCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 16),
          ...values.asMap().entries.map(
                (entity) => Column(
                  children: [
                    if (entity.key != 0) ...{
                      const DividerCardWidget(),
                    },
                    RowWithDataWidget(
                        title: entity.value.key, value: entity.value.value),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class KeyValue {
  final String key;
  final String value;

  KeyValue(this.key, this.value);
}
