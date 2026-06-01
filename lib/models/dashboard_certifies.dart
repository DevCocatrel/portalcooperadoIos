class DashboardCertifies {
  final String name;
  final String farmName;
  final String inscription;
  final String expirationDate;

  DashboardCertifies({
    required this.name,
    required this.farmName,
    required this.inscription,
    required this.expirationDate,
  });

  factory DashboardCertifies.fromJson(Map<String, dynamic> json) {
    return DashboardCertifies(
      name: json['Certificado'],
      farmName: json['Fazenda'],
      inscription: json['NumeroCertificado'],
      expirationDate: json['DataVencimento'],
    );
  }
}
