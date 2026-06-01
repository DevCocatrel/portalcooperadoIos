class BulletinModel {
  String? bulletinCode;
  String? contactCode;
  String? identifier;
  String? propertyName;
  String? completionDate;
  String? entryDate;
  String? contactName;
  String? paymentDate;
  String? bulletinType;
  String? bulletinPaid;

  BulletinModel({
    this.bulletinCode,
    this.contactCode,
    this.identifier,
    this.propertyName,
    this.completionDate,
    this.entryDate,
    this.contactName,
    this.paymentDate,
    this.bulletinType,
    this.bulletinPaid,
  });

  // Method to convert JSON to a Bulletin object
  factory BulletinModel.fromJson(Map<String, dynamic> json) {
    return BulletinModel(
      bulletinCode: json['CodigoBoletim'],
      contactCode: json['CodigoContato'],
      identifier: json['Handle'],
      propertyName: json['NomePropriedade'],
      completionDate: json['DataConclusao'],
      entryDate: json['DataEntrada'],
      contactName: json['NomeContato'],
      paymentDate: json['DataPagamento'],
      bulletinType: json['TipoBoletim'],
      bulletinPaid: json['BoletimPago'],
    );
  }

  // Method to convert Bulletin object to JSON
  Map<String, dynamic> toJson() {
    return {
      'CodigoBoletim': bulletinCode,
      'CodigoContato': contactCode,
      'Handle': identifier,
      'NomePropriedade': propertyName,
      'DataConclusao': completionDate,
      'DataEntrada': entryDate,
      'NomeContato': contactName,
      'DataPagamento': paymentDate,
      'TipoBoletim': bulletinType,
      'BoletimPago': bulletinPaid,
    };
  }
}
