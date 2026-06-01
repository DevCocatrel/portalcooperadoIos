class DepositFarmListModel {
  String? cooperatedName;
  String? cooperatedType;
  List<Farm>? farmList;
  List<dynamic>? invoiceList;
  double? coffeePrice;
  double? coffeeRepassPrice;
  double? maxInvoiceValue;
  String? invoiceMessage;

  DepositFarmListModel({
    this.cooperatedName,
    this.cooperatedType,
    this.farmList,
    this.invoiceList,
    this.coffeePrice,
    this.coffeeRepassPrice,
    this.maxInvoiceValue,
    this.invoiceMessage,
  });

  DepositFarmListModel.initialize() {
    farmList = [Farm()];
  }

  factory DepositFarmListModel.fromJson(Map<String, dynamic> json) {
    return DepositFarmListModel(
      cooperatedName: json['NomeCooperado'] as String?,
      cooperatedType: json['TipoCooperado'] as String?,
      farmList: (json['ListaFazendas'] as List<dynamic>?)
          ?.map((e) => Farm.fromJson(e as Map<String, dynamic>))
          .toList(),
      invoiceList: json['ListaNFe'] as List<dynamic>?,
      coffeePrice: (json['PrecoCafe_cafe'] as num?)?.toDouble(),
      coffeeRepassPrice: (json['PrecoCafe_repasseEscolha'] as num?)?.toDouble(),
      maxInvoiceValue: (json['ValorMaximoDaNFe'] as num?)?.toDouble(),
      invoiceMessage: json['MensagemParaNFe'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NomeCooperado': cooperatedName,
      'TipoCooperado': cooperatedType,
      'ListaFazendas': farmList?.map((e) => e.toJson()).toList(),
      'ListaNFe': invoiceList,
      'PrecoCafe_cafe': coffeePrice,
      'PrecoCafe_repasseEscolha': coffeeRepassPrice,
      'ValorMaximoDaNFe': maxInvoiceValue,
      'MensagemParaNFe': invoiceMessage,
    };
  }
}

class Farm {
  String? registrationNumber;
  String? farmName;
  String? farmCity;

  Farm({
    this.registrationNumber,
    this.farmName,
    this.farmCity,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      registrationNumber: json['numInscricao'] as String?,
      farmName: json['nomeFazenda'] as String?,
      farmCity: json['cidadeFazenda'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numInscricao': registrationNumber,
      'nomeFazenda': farmName,
      'cidadeFazenda': farmCity,
    };
  }
}
