class AuthorizationSaleBatchesModel {
  final String batch;
  final String entryDate;
  final String drinkClassification;
  final String harvestClassification;
  final String customClassification;
  final double classificationPerBreak;
  final String beanClassification;
  final String dryClassification;
  final String standardClassification;
  final double balanceEntryBags;
  final double balanceBags;
  final double blockedBalanceBags;
  final double authorizedBags;
  final double availableBags;
  final double grossUnitPrice;
  final double netUnitPrice;
  final String goodBarrelDrink;
  final String sampleName;
  final String backgroundColor;
  final String textColor;

  AuthorizationSaleBatchesModel({
    required this.batch,
    required this.entryDate,
    required this.drinkClassification,
    required this.harvestClassification,
    required this.customClassification,
    required this.classificationPerBreak,
    required this.beanClassification,
    required this.dryClassification,
    required this.standardClassification,
    required this.balanceEntryBags,
    required this.balanceBags,
    required this.blockedBalanceBags,
    required this.authorizedBags,
    required this.availableBags,
    required this.grossUnitPrice,
    required this.netUnitPrice,
    required this.goodBarrelDrink,
    required this.sampleName,
    required this.backgroundColor,
    required this.textColor,
  });

  factory AuthorizationSaleBatchesModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationSaleBatchesModel(
      batch: json['Lote'],
      entryDate: json['LoteDataEntrada'],
      drinkClassification: json['ClassificacaoBebida'],
      harvestClassification: json['ClassificacaoSafra'],
      customClassification: json['ClassificacaoPersonalizado'],
      classificationPerBreak: json['ClassificacaoPerQuebra'],
      beanClassification: json['ClassificacaoFava'],
      dryClassification: json['ClassificacaoSeca'],
      standardClassification: json['ClassificacaoPadrao'],
      balanceEntryBags: json['SaldoSacasEntrada'],
      balanceBags: json['SaldoSacas'],
      blockedBalanceBags: json['SaldoSacasBloqueada'],
      authorizedBags: json['SacasAutorizadasVenda'],
      availableBags: json['SacasDisponivel'],
      grossUnitPrice: json['PrecoUnitarioBruto'],
      netUnitPrice: json['PrecoUnitarioLiquido'],
      goodBarrelDrink: json['BOM_BARR_BEB'],
      sampleName: json['NOM_AMOSTRA'],
      backgroundColor: json['CodigoCorFundo'],
      textColor: json['CodigoCorTexto'],
    );
  }
}
