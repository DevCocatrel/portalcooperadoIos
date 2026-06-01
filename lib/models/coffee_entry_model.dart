class CoffeeEntryModel {
  int? cooperatedCode;
  String? cooperatedName;
  String? cooperatedFJ;
  String? issueDate;
  String? farmCertificates;
  String? farmCertificateCode;
  List<CarrierModel>? carriers;
  double? coffeePrice;
  double? coffeePriceChoice;
  double? maxInvoiceValue;
  String? invoiceMessage;
  String? personalizedCoffee;
  List<WarehouseModel>? warehouses;
  List<PackagingModel>? packaging;

  CoffeeEntryModel({
    this.cooperatedCode,
    this.cooperatedName,
    this.cooperatedFJ,
    this.issueDate,
    this.farmCertificates,
    this.farmCertificateCode,
    this.carriers,
    this.coffeePrice,
    this.coffeePriceChoice,
    this.maxInvoiceValue,
    this.invoiceMessage,
    this.personalizedCoffee,
    this.warehouses,
    this.packaging,
  });

  factory CoffeeEntryModel.initialize() {
    return CoffeeEntryModel(
        carriers: [CarrierModel()],
        packaging: [PackagingModel()],
        warehouses: [WarehouseModel()]);
  }

  factory CoffeeEntryModel.fromJson(Map<String, dynamic> json) {
    return CoffeeEntryModel(
      cooperatedCode: json['CodigoCooperado'],
      cooperatedName: json['NomeCooperado'],
      cooperatedFJ: json['CooperadoFJ'],
      issueDate: json['DataEmissao'],
      farmCertificates: json['CertificadosFazenda'],
      farmCertificateCode: json['CodigoCertificadoFazenda'],
      carriers: json['Transportadoras'] != null
          ? (json['Transportadoras'] as List)
              .map((i) => CarrierModel.fromJson(i))
              .toList()
          : null,
      coffeePrice: (json['PrecoCafe'] as num?)?.toDouble(),
      coffeePriceChoice: (json['PrecoCafe_escolha'] as num?)?.toDouble(),
      maxInvoiceValue: (json['ValMaxNFe'] as num?)?.toDouble(),
      invoiceMessage: json['MensagemNFe'],
      personalizedCoffee: json['CafePersonalizado'],
      warehouses: json['Armazens'] != null
          ? (json['Armazens'] as List)
              .map((i) => WarehouseModel.fromJson(i))
              .toList()
          : null,
      packaging: json['Embalagens'] != null
          ? (json['Embalagens'] as List)
              .map((i) => PackagingModel.fromJson(i))
              .toList()
          : null,
    );
  }
}

class CarrierModel {
  int? carrierCode;
  String? carrierName;
  String? carrierUf;
  String? vehiclePlate;

  CarrierModel({
    this.carrierCode,
    this.carrierName,
    this.carrierUf,
    this.vehiclePlate,
  });

  factory CarrierModel.fromJson(Map<String, dynamic> json) {
    return CarrierModel(
      carrierCode: json['CodigoTransportadora'],
      carrierName: json['NomeTransportadora'],
      carrierUf: json['UfTransportadora'],
      vehiclePlate: json['PlacaVeiculo'],
    );
  }
}

class WarehouseModel {
  int? warehouseCode;
  String? warehouseName;

  WarehouseModel({
    this.warehouseCode,
    this.warehouseName,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      warehouseCode: json['CodigoArmazen'],
      warehouseName: json['NomeArmazen'],
    );
  }
}

class PackagingModel {
  String? packagingCode;
  String? packagingName;

  PackagingModel({
    this.packagingCode,
    this.packagingName,
  });

  factory PackagingModel.fromJson(Map<String, dynamic> json) {
    return PackagingModel(
      packagingCode: json['CodigoEmbalagem'],
      packagingName: json['NomeEmbalagem'],
    );
  }
}
