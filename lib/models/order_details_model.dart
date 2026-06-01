import 'package:cocatrel/models/order_details_authorization_model.dart';
import 'package:cocatrel/models/order_details_history_model.dart';

class OrderDetailsModel {
  final String? cooperateName;
  final String farmName;
  final String inscription;
  final double totalDebt;
  final double totalCredit;
  final double totalBalance;
  final List<OrderDetailsAuthorizationModel> authorizations;
  final List<OrderDetailsHistoryModel> histories;

  OrderDetailsModel({
    required this.cooperateName,
    required this.farmName,
    required this.inscription,
    required this.totalDebt,
    required this.totalCredit,
    required this.totalBalance,
    required this.authorizations,
    required this.histories,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      cooperateName: json['NomeCooperado'],
      farmName: json['NomeFazenda'],
      inscription: json['NumeroInscricao'],
      totalDebt: json['TotalDebitos'],
      totalCredit: json['TotalCreditos'],
      totalBalance: json['SaldoTotal'],
      authorizations: (json['ListaAmostrasAutVendaCafe'] as List)
          .map((authorization) =>
              OrderDetailsAuthorizationModel.fromJson(authorization))
          .toList(),
      histories: (json['ListaSaldosAutVendaCafe'] as List)
          .map((history) => OrderDetailsHistoryModel.fromJson(history))
          .toList(),
    );
  }
}
