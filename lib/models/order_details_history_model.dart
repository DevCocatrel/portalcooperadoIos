class OrderDetailsHistoryModel {
  final String name;
  final String type;
  final double balance;
  final double calculatedBalance;

  OrderDetailsHistoryModel({
    required this.name,
    required this.type,
    required this.balance,
    required this.calculatedBalance,
  });

  factory OrderDetailsHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsHistoryModel(
      name: json['Historico'],
      type: json['Tipo_DC'],
      balance: json['Saldo'],
      calculatedBalance: json['SaldoCalculado'],
    );
  }
}
