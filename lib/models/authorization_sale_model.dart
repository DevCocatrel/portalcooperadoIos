class AuthorizationSaleDetailsModel {
  final String cooperateName;
  final String farmName;
  final String inscriptionNumber;
  final double totalDebits;
  final double totalCredits;
  final double totalBalance;
  final List<AuthorizationSaleSampleListModel> samples;
  final List<AuthorizationSaleBalanceListModel> balances;

  AuthorizationSaleDetailsModel({
    required this.cooperateName,
    required this.farmName,
    required this.inscriptionNumber,
    required this.totalDebits,
    required this.totalCredits,
    required this.totalBalance,
    required this.samples,
    required this.balances,
  });

  factory AuthorizationSaleDetailsModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationSaleDetailsModel(
        cooperateName: json['NomeCooperado'],
        farmName: json['NomeFazenda'],
        inscriptionNumber: json['NumeroInscricao'],
        totalDebits: json['TotalDebitos'],
        totalCredits: json['TotalCreditos'],
        totalBalance: json['SaldoTotal'],
        samples: (json['ListaAmostrasAutVendaCafe'] as List)
            .map((json) => AuthorizationSaleSampleListModel.fromJson(json))
            .toList(),
        balances: (json['ListaSaldosAutVendaCafe'] as List)
            .map((json) => AuthorizationSaleBalanceListModel.fromJson(json))
            .toList());
  }
}

class AuthorizationSaleBalanceListModel {
  final String history;
  final String dcType;
  final double balance;
  final double calculatedBalance;

  AuthorizationSaleBalanceListModel({
    required this.history,
    required this.dcType,
    required this.balance,
    required this.calculatedBalance,
  });

  factory AuthorizationSaleBalanceListModel.fromJson(
      Map<String, dynamic> json) {
    return AuthorizationSaleBalanceListModel(
      history: json['Historico'],
      dcType: json['Tipo_DC'],
      balance: json['Saldo'],
      calculatedBalance: json['SaldoCalculado'],
    );
  }
}

class AuthorizationSaleSampleListModel {
  final String lot;
  final String harvest;
  final String entryDate;
  final double bags;
  final double price;
  final String standard;
  final String screening;
  final String sieve;
  final String dry;
  final String certifier;
  final String dryProc;

  AuthorizationSaleSampleListModel({
    required this.lot,
    required this.harvest,
    required this.entryDate,
    required this.bags,
    required this.price,
    required this.standard,
    required this.screening,
    required this.sieve,
    required this.dry,
    required this.certifier,
    required this.dryProc,
  });

  factory AuthorizationSaleSampleListModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationSaleSampleListModel(
      lot: json['Lote'],
      harvest: json['Safra'],
      entryDate: json['DataEntrada'],
      bags: json['Sacas'],
      price: json['Preco'],
      standard: json['Padrao'],
      screening: json['Catacao'],
      sieve: json['Peneira'],
      dry: json['Seca'],
      certifier: json['Certificador'],
      dryProc: json['ProcSeca'],
    );
  }
}
