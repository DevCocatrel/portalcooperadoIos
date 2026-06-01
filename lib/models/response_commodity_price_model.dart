import 'package:cocatrel/models/market_price_model.dart';

class ResponseCommodityPriceModel {
  String? dataHoraCotacao;
  List<MarketPriceModel>? cotacoes;

  ResponseCommodityPriceModel({this.dataHoraCotacao, this.cotacoes});

  ResponseCommodityPriceModel.fromJson(Map<String, dynamic> json) {
    dataHoraCotacao = json['DataHoraCotacao'];
    if (json['Cotacoes'] != null && json['Cotacoes'] is List) {
      final list = (json['Cotacoes'] as List)
          .map((item) => MarketPriceModel.fromJson(item))
          .toList();
      cotacoes = list;
    }
  }
}
