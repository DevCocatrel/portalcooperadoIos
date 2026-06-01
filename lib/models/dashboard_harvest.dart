class DashboardHarvest {
  final String year;
  final double quantity;

  DashboardHarvest({
    required this.year,
    required this.quantity,
  });

  factory DashboardHarvest.fromJson(Map<String, dynamic> json) {
    return DashboardHarvest(
      year: json['Safra'],
      quantity: json['QuantidadeSacas'],
    );
  }
}
