import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LotModel {
  String? lotNumber; // NUM_LOTE
  DateTime? entryDate; // DAT_ENTRADA
  String? harvest; // SAFRA
  String? invoiceNumber; // NUM_NF
  String? certifier; // CERTIFICADOR
  double? quantityReceived; // QTD_ENTRADA
  double? balanceBags; // QTD_SALDO_SACAS
  double? blockedQuantity; // QTD_BLOQUEADO
  double? authorizedQuantity; // QTD_AUTORIZADA
  double? availableQuantity; // QTD_DISPONIVEL
  String? standardName; // NOM_PADRAO
  double? breakagePercentage; // PER_QUEBRA
  String? favoriteName; // NOME_FAV
  String? dryingName; // NOM_SECA
  double? score; // num_pontuacao
  double? grossUnitValue; // val_unitario_bruto
  double? icmsValue; // val_icms
  double? expensesValue; // val_despesas
  double? customizedValue; // val_personalizado
  double? inssValue; // val_inss
  double? capitalRetentionValue; // val_retencao_capital
  double? netUnitValue; // val_unitario_liquido
  double? netValue; // val_liquido
  String? backgroundColorCode; // CodigoCorFundo
  String? textColorCode; // CodigoCorTexto

  String? get entryDateFormatted {
    if (entryDate != null) {
      return DateFormat('dd/MM/yyyy').format(entryDate!);
    }
    return null;
  }

  LotModel({
    this.lotNumber,
    this.entryDate,
    this.harvest,
    this.invoiceNumber,
    this.certifier,
    this.quantityReceived,
    this.balanceBags,
    this.blockedQuantity,
    this.authorizedQuantity,
    this.availableQuantity,
    this.standardName,
    this.breakagePercentage,
    this.favoriteName,
    this.dryingName,
    this.score,
    this.grossUnitValue,
    this.icmsValue,
    this.expensesValue,
    this.customizedValue,
    this.inssValue,
    this.capitalRetentionValue,
    this.netUnitValue,
    this.netValue,
    this.backgroundColorCode,
    this.textColorCode,
  });

  LotModel.empty();

  LotModel.fromJson(Map<String, dynamic> json) {
    lotNumber = json['NUM_LOTE'];
    entryDate = DateTime.parse(json['DAT_ENTRADA']);
    harvest = json['SAFRA'];
    invoiceNumber = json['NUM_NF'];
    certifier = json['CERTIFICADOR'];
    quantityReceived = (json['QTD_ENTRADA'] as num?)?.toDouble();
    balanceBags = (json['QTD_SALDO_SACAS'] as num?)?.toDouble();
    blockedQuantity = (json['QTD_BLOQUEADO'] as num?)?.toDouble();
    authorizedQuantity = (json['QTD_AUTORIZADA'] as num?)?.toDouble();
    availableQuantity = (json['QTD_DISPONIVEL'] as num?)?.toDouble();
    standardName = json['NOM_PADRAO'];
    breakagePercentage = (json['PER_QUEBRA'] as num?)?.toDouble();
    favoriteName = json['NOME_FAV'];
    dryingName = json['NOM_SECA'];
    score = (json["num_pontuacao"] as num?)?.toDouble();
    grossUnitValue = (json['val_unitario_bruto'] as num?)?.toDouble();
    icmsValue = (json['val_icms'] as num?)?.toDouble();
    expensesValue = (json['val_despesas'] as num?)?.toDouble();
    customizedValue = (json['val_personalizado'] as num?)?.toDouble();
    inssValue = (json['val_inss'] as num?)?.toDouble();
    capitalRetentionValue = (json['val_retencao_capital'] as num?)?.toDouble();
    netUnitValue = (json['val_unitario_liquido'] as num?)?.toDouble();
    netValue = (json['val_liquido'] as num?)?.toDouble();
    backgroundColorCode = json['CodigoCorFundo'];
    textColorCode = json['CodigoCorTexto'];
  }

  Color? get backgroundColor {
    if (backgroundColorCode != null) {
      Color color = Color(int.tryParse(
              'FF$backgroundColorCode'.replaceAll('#', ''),
              radix: 16) ??
          0);
      return color;
    }
    return null;
  }

  Color? get textColor {
    Color color =
        Color(int.parse('FF$textColorCode'.replaceAll('#', ''), radix: 16));
    return color;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NUM_LOTE'] = lotNumber;
    data['DAT_ENTRADA'] = entryDate?.toIso8601String();
    data['SAFRA'] = harvest;
    data['NUM_NF'] = invoiceNumber;
    data['CERTIFICADOR'] = certifier;
    data['QTD_ENTRADA'] = quantityReceived;
    data['QTD_SALDO_SACAS'] = balanceBags;
    data['QTD_BLOQUEADO'] = blockedQuantity;
    data['QTD_AUTORIZADA'] = authorizedQuantity;
    data['QTD_DISPONIVEL'] = availableQuantity;
    data['NOM_PADRAO'] = standardName;
    data['PER_QUEBRA'] = breakagePercentage;
    data['NOME_FAV'] = favoriteName;
    data['NOM_SECA'] = dryingName;
    data['num_pontuacao'] = score;
    data['val_unitario_bruto'] = grossUnitValue;
    data['val_icms'] = icmsValue;
    data['val_despesas'] = expensesValue;
    data['val_personalizado'] = customizedValue;
    data['val_inss'] = inssValue;
    data['val_retencao_capital'] = capitalRetentionValue;
    data['val_unitario_liquido'] = netUnitValue;
    data['val_liquido'] = netValue;
    data['CodigoCorFundo'] = backgroundColorCode;
    data['CodigoCorTexto'] = textColorCode;
    return data;
  }
}
