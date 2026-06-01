import 'package:cocatrel/models/order_model.dart';

class OrdersModel {
  final List<OrderModel> orders;

  OrdersModel({
    required this.orders,
  });

  factory OrdersModel.fromJson(List<dynamic> json) {
    return OrdersModel(
      orders: json.map((order) => OrderModel.fromJson(order)).toList(),
    );
  }
}
