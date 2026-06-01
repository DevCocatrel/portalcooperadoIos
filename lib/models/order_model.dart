import 'package:cocatrel/models/order_authorization_model.dart';

class OrderModel {
  final String cooperateName;
  final String saleNumber;
  final String saleDate;
  final String saleExpirationDate;
  final double bagsSold;
  final String saleStatus;
  final List<OrderAuthorizationModel> authorizations;

  OrderModel({
    required this.cooperateName,
    required this.saleNumber,
    required this.saleDate,
    required this.saleExpirationDate,
    required this.bagsSold,
    required this.saleStatus,
    required this.authorizations,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      cooperateName: json['NomeCooperado'],
      saleNumber: json['NumVenda'],
      saleDate: json['DataVenda'],
      saleExpirationDate: json['DataVencimento'],
      bagsSold: json['QtdSacas'],
      saleStatus: json['StatusPagamento'],
      authorizations: (json['ListaAutorizacoes'] as List)
          .map((authorization) =>
              OrderAuthorizationModel.fromJson(authorization))
          .toList(),
    );
  }
}
