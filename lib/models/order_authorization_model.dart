class OrderAuthorizationModel {
  final String saleNumber;
  final String authorizationNumber;
  final String authorizationDate;

  OrderAuthorizationModel({
    required this.saleNumber,
    required this.authorizationNumber,
    required this.authorizationDate,
  });

  factory OrderAuthorizationModel.fromJson(Map<String, dynamic> json) {
    return OrderAuthorizationModel(
      saleNumber: json['NumVenda'],
      authorizationNumber: json['NumAutorizacao'],
      authorizationDate: json['DataOperacao'],
    );
  }
}
