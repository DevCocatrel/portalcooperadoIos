class DashboardBalancePerQuoteClassificationModel {
  final String classification;
  final double balance;
  final String backgroundColor;

  DashboardBalancePerQuoteClassificationModel({
    required this.classification,
    required this.balance,
    required this.backgroundColor,
  });

  factory DashboardBalancePerQuoteClassificationModel.fromJson(
      Map<String, dynamic> json) {
    return DashboardBalancePerQuoteClassificationModel(
      classification: json['Bebida'],
      balance: json['QuantidadeSacas'],
      backgroundColor: json['CorBebida'],
    );
  }
}
