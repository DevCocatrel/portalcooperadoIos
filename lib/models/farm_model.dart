class FarmModel {
  String? cooperatorName;
  String? farm;
  String? farmRegistration;
  double? balance;
  double? blockedBalance;
  double? authorizedBalance;
  double? availableBalance;

  FarmModel(
      {this.cooperatorName,
      this.farm,
      this.farmRegistration,
      this.balance,
      this.blockedBalance,
      this.authorizedBalance,
      this.availableBalance});

  FarmModel.fromJson(Map<String, dynamic> json) {
    cooperatorName = json['cooperatorName'];
    farm = json['Fazenda'];
    farmRegistration = json['Inscricao'];
    balance = json['Saldo'];
    blockedBalance = (json['SaldoBloqueado'] ?? .0) + .0;
    authorizedBalance = (json['SaldoAutorizado'] ?? .0) + .0;
    availableBalance = (json['SaldoDisponivel'] ?? .0) + .0;
  }

  FarmModel.empty() {
    balance = .0;
    cooperatorName = 'Cooperado';
    farm = 'Fazenda';
    farmRegistration = '000000000';
    authorizedBalance = .0;
    blockedBalance = .0;
    availableBalance = .0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NomeCooperado'] = cooperatorName;
    data['Fazenda'] = farm;
    data['Inscricao'] = farmRegistration;
    data['Saldo'] = balance;
    data['SaldoBloqueado'] = blockedBalance;
    data['SaldoAutorizado'] = authorizedBalance;
    data['SaldoDisponivel'] = availableBalance;
    return data;
  }
}
