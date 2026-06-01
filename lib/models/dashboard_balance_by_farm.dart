class DashboardBalanceByFarm {
  final String name;
  final String inscription;
  final double balance;
  final double blocked;

  DashboardBalanceByFarm({
    required this.name,
    required this.inscription,
    required this.balance,
    required this.blocked,
  });

  factory DashboardBalanceByFarm.fromJson(Map<String, dynamic> json) {
    return DashboardBalanceByFarm(
      name: json['Fazenda'],
      inscription: json['Inscricao'],
      balance: json['Saldo'],
      blocked: json['SaldoBloqueado'],
    );
  }
}
