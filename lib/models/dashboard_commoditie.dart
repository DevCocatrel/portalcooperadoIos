class DashboardCommoditie {
  final String contract;
  final String contractDescription;
  final double value;
  final double difference;
  final double percentage;
  final String position;

  DashboardCommoditie({
    required this.contract,
    required this.contractDescription,
    required this.value,
    required this.difference,
    required this.percentage,
    required this.position,
  });

  factory DashboardCommoditie.fromJson(Map<String, dynamic> json) {
    return DashboardCommoditie(
      contract: json['Contrato'],
      contractDescription: json['DescContrato'],
      value: double.tryParse(json['Cotacao']) ?? 0,
      difference: double.tryParse(json['Dif']) ?? 0,
      percentage: double.tryParse(json['Percentual']) ?? 0,
      position: json['Posicao'],
    );
  }
}
