class LastInvoiceList {
  String? cooperatedName;
  String? cooperatedType;
  List<FarmModel>? farmList;
  List<NFeModel>? nfeList;
  double? coffeePrice;
  double? selectionRepassePrice;
  double? maxNFeValue;
  String? nfeMessage;

  LastInvoiceList({
    this.cooperatedName,
    this.cooperatedType,
    this.farmList,
    this.nfeList,
    this.coffeePrice,
    this.selectionRepassePrice,
    this.maxNFeValue,
    this.nfeMessage,
  });

  factory LastInvoiceList.fromJson(Map<String, dynamic> json) {
    return LastInvoiceList(
      cooperatedName: json['NomeCooperado'],
      cooperatedType: json['TipoCooperado'],
      farmList: (json['ListaFazendas'] as List<dynamic>?)
          ?.map((item) => FarmModel.fromJson(item))
          .toList(),
      nfeList: (json['ListaNFe'] as List<dynamic>?)
          ?.map((item) => NFeModel.fromJson(item))
          .toList(),
      coffeePrice: (json['PrecoCafe_cafe'] as num?)?.toDouble(),
      selectionRepassePrice:
          (json['PrecoCafe_repasseEscolha'] as num?)?.toDouble(),
      maxNFeValue: (json['ValorMaximoDaNFe'] as num?)?.toDouble(),
      nfeMessage: json['MensagemParaNFe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NomeCooperado': cooperatedName,
      'TipoCooperado': cooperatedType,
      'ListaFazendas': farmList?.map((item) => item.toJson()).toList(),
      'ListaNFe': nfeList?.map((item) => item.toJson()).toList(),
      'PrecoCafe_cafe': coffeePrice,
      'PrecoCafe_repasseEscolha': selectionRepassePrice,
      'ValorMaximoDaNFe': maxNFeValue,
      'MensagemParaNFe': nfeMessage,
    };
  }
}

class FarmModel {
  // Fields for the farm can be added here when available.
  FarmModel();

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class NFeModel {
  String? cancellationDate;
  String? registrationDate;
  String? statusFlag;
  String? registrationHan;
  String? accessKeyNumber;
  String? documentNumber;
  String? registrationNumber;
  String? bags;
  String? farmName;

  NFeModel({
    this.cancellationDate,
    this.registrationDate,
    this.statusFlag,
    this.registrationHan,
    this.accessKeyNumber,
    this.documentNumber,
    this.registrationNumber,
    this.bags,
    this.farmName,
  });

  factory NFeModel.fromJson(Map<String, dynamic> json) {
    return NFeModel(
      cancellationDate: json['dat_cancelamento'],
      registrationDate: json['dat_registro'],
      statusFlag: json['flg_status'],
      registrationHan: json['han_registro'],
      accessKeyNumber: json['num_chave_acesso'],
      documentNumber: json['num_doc'],
      registrationNumber: json['num_inscricao'],
      bags: json['sacas'],
      farmName: json['nomeFazenda'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dat_cancelamento': cancellationDate,
      'dat_registro': registrationDate,
      'flg_status': statusFlag,
      'han_registro': registrationHan,
      'num_chave_acesso': accessKeyNumber,
      'num_doc': documentNumber,
      'num_inscricao': registrationNumber,
      'sacas': bags,
      'nomeFazenda': farmName,
    };
  }
}
