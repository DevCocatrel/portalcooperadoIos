class BondsPayableModel {
  List<BondPayableModel>? bondPayableList;
  double? totalBondsPayable;

  BondsPayableModel({this.bondPayableList, this.totalBondsPayable});

  BondsPayableModel.fromJson(json) {
    if (json['TitulosPagar'] != null && json['TitulosPagar'] is List) {
      final list = (json['TitulosPagar'] as List)
          .map((data) => BondPayableModel.fromJson(data))
          .toList();
      bondPayableList = list;
    }
    totalBondsPayable = (json['TotalTitulosPagar'] as num?)?.toDouble();
  }
}

class BondPayableModel {
  String? accountingId;
  double? amount;
  DateTime? postingDate;
  String? documentType;
  String? assignment;
  String? status;
  DateTime? dueDate;
  int? daysLate;
  double? interestAmount;
  double? totalToPay;
  String? reference;

  BondPayableModel({
    this.accountingId,
    this.amount,
    this.postingDate,
    this.documentType,
    this.assignment,
    this.status,
    this.dueDate,
    this.daysLate,
    this.interestAmount,
    this.totalToPay,
    this.reference,
  });

  // Factory method to create an instance from a JSON object
  factory BondPayableModel.fromJson(Map<String, dynamic> json) {
    return BondPayableModel(
      accountingId: json['IdContabil'] as String?,
      amount: (json['Montante'] as num?)?.toDouble(),
      postingDate: json['DataLancamento'] != null
          ? DateTime.parse(json['DataLancamento'])
          : null,
      documentType: json['TipoDocumento'] as String?,
      assignment: json['Atribuicao'] as String?,
      status: json['Status'] as String?,
      dueDate: json['DataVencimento'] != null
          ? DateTime.parse(json['DataVencimento'])
          : null,
      daysLate: json['DiasAtraso'] as int?,
      interestAmount: (json['ValorJuros'] as num?)?.toDouble(),
      totalToPay: (json['TotalPagar'] as num?)?.toDouble(),
      reference: json['Referencia'] as String?,
    );
  }

  // Method to convert an instance of this class to JSON format
  Map<String, dynamic> toJson() {
    return {
      'IdContabil': accountingId,
      'Montante': amount,
      'DataLancamento': postingDate?.toIso8601String(),
      'TipoDocumento': documentType,
      'Atribuicao': assignment,
      'Status': status,
      'DataVencimento': dueDate?.toIso8601String(),
      'DiasAtraso': daysLate,
      'ValorJuros': interestAmount,
      'TotalPagar': totalToPay,
      'Referencia': reference,
    };
  }
}
