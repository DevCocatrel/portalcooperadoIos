class AuthorizationSaleModel {
  final String cooperateName;
  final double openTitles;
  final List<AuthorizationSaleFarmBalanceModel> farms;
  final List<AuthorizationSaleBankAccountModel> bankAccounts;
  final List<AuthorizationSalePendingModel> pending;

  AuthorizationSaleModel({
    required this.cooperateName,
    required this.openTitles,
    required this.farms,
    required this.bankAccounts,
    required this.pending,
  });

  factory AuthorizationSaleModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationSaleModel(
      cooperateName: json['NomeCooperado'],
      openTitles: json['TotalTitulosAberto'],
      farms: (json['SaldoFazendas'] as List)
          .map((farm) => AuthorizationSaleFarmBalanceModel.fromJson(farm))
          .toList(),
      bankAccounts: (json['ContasBancarias'] as List).map((bankAccount) {
        return AuthorizationSaleBankAccountModel.fromJson(bankAccount);
      }).toList(),
      pending: (json['AutorizacoesPendentes'] as List)
          .map((pendingSale) =>
              AuthorizationSalePendingModel.fromJson(pendingSale))
          .toList(),
    );
  }
}

class AuthorizationSalePendingModel {
  final String value;
  final String date;
  final String farmInscription;
  final String farmName;
  final String bags;
  final String standard;
  final String payment;
  final String priceType;
  final String status;
  final String statusFlag;
  final double unitPrice;
  final double totalPrice;

  AuthorizationSalePendingModel({
    required this.value,
    required this.date,
    required this.farmInscription,
    required this.farmName,
    required this.bags,
    required this.standard,
    required this.payment,
    required this.priceType,
    required this.status,
    required this.statusFlag,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory AuthorizationSalePendingModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationSalePendingModel(
      value: json['Numero'],
      date: json['Data'],
      farmInscription: json['InscricaoFazenda'],
      farmName: json['NomeFazenda'],
      bags: json['Sacas'],
      standard: json['Padrao'],
      payment: json['Pagamento'],
      priceType: json['TipoPreco'],
      status: json['Status'],
      statusFlag: json['FlgStatus'],
      unitPrice: json['PrUnit'],
      totalPrice: json['PrTotal'],
    );
  }
}

class AuthorizationSaleBankAccountModel {
  final String bank;
  final String agency;
  final String account;
  final String id;

  AuthorizationSaleBankAccountModel({
    required this.bank,
    required this.agency,
    required this.account,
    required this.id,
  });

  factory AuthorizationSaleBankAccountModel.fromJson(
      Map<String, dynamic> json) {
    return AuthorizationSaleBankAccountModel(
      bank: json['Banco'],
      agency: json['Agencia'],
      account: json['Conta'],
      id: json['IdConta'],
    );
  }
}

class AuthorizationSaleFarmBalanceModel {
  final String cooperateName;
  final String name;
  final String inscription;
  final double balance;
  final double blockedBalance;
  final double authorizedBalance;
  final double availableBalance;

  AuthorizationSaleFarmBalanceModel({
    required this.cooperateName,
    required this.name,
    required this.inscription,
    required this.balance,
    required this.blockedBalance,
    required this.authorizedBalance,
    required this.availableBalance,
  });

  factory AuthorizationSaleFarmBalanceModel.fromJson(
      Map<String, dynamic> json) {
    return AuthorizationSaleFarmBalanceModel(
      cooperateName: json['NomeCooperado'],
      name: json['Fazenda'],
      inscription: json['Inscricao'],
      balance: json['Saldo'],
      blockedBalance: json['SaldoBloqueado'],
      authorizedBalance: json['SaldoAutorizado'],
      availableBalance: json['SaldoDisponivel'],
    );
  }
}
