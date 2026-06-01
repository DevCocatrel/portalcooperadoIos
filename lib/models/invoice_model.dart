class InvoiceModel {
  String? title;
  String? cpfCnpj;
  double? invoiceAmount;
  String? ourNumber;
  String? dueDate;
  String? generateLink;
  String? invoiceType;
  String? invoiceLink;

  InvoiceModel({
    this.title,
    this.cpfCnpj,
    this.invoiceAmount,
    this.ourNumber,
    this.dueDate,
    this.generateLink,
    this.invoiceType,
    this.invoiceLink,
  });

  // Function to convert from JSON to Invoice
  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      title: json['Titulo'] as String?,
      cpfCnpj: json['CpfCnpj'] as String?,
      invoiceAmount: (json['ValorTitulo'] as num?)?.toDouble(),
      ourNumber: json['NossoNumero'] as String?,
      dueDate: json['Vencimento'] as String?,
      generateLink: json['GeraLink'] as String?,
      invoiceType: json['TipoBoleto'] as String?,
      invoiceLink: json['LinkBoleto'] as String?,
    );
  }

  // Function to convert from Invoice to JSON
  Map<String, dynamic> toJson() {
    return {
      'Titulo': title,
      'CpfCnpj': cpfCnpj,
      'ValorTitulo': invoiceAmount,
      'NossoNumero': ourNumber,
      'Vencimento': dueDate,
      'GeraLink': generateLink,
      'TipoBoleto': invoiceType,
      'LinkBoleto': invoiceLink,
    };
  }
}

class InvoiceList {
  String? memberName;
  int? hasGenerateLink;
  List<InvoiceModel>? invoices;

  InvoiceList({
    this.memberName,
    this.hasGenerateLink,
    this.invoices,
  });

  // Function to convert from JSON to CooperativeMemberModel
  factory InvoiceList.fromJson(Map<String, dynamic> json) {
    return InvoiceList(
      memberName: json['NomeCooperado'] as String?,
      hasGenerateLink: json['TemGeraLink'] as int?,
      invoices: (json['Boletos'] as List<dynamic>?)
          ?.map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Function to convert from CooperativeMemberModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'NomeCooperado': memberName,
      'TemGeraLink': hasGenerateLink,
      'Boletos': invoices?.map((e) => e.toJson()).toList(),
    };
  }
}
