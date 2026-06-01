import 'package:cocatrel/models/market_price_model.dart';
import 'package:cocatrel/models/response_commodity_price_model.dart';
import 'package:cocatrel/repositories/commodity_price_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class CommodityPriceController extends ChangeNotifier {
  CommodityPriceController() {
    fetchCommodityPrices();
    loop();
  }
  bool loading = false;

  void loop() async {
    await Future.delayed(const Duration(seconds: 15));
    await fetchCommodityPrices();
    return loop();
  }

  Either<Exception, ResponseCommodityPriceModel> data = Right(
    ResponseCommodityPriceModel(dataHoraCotacao: "", cotacoes: [
      MarketPriceModel.empty(),
    ]),
  );

  List<Group> group = [
    Group(
      'title',
    )..marketPrices = [MarketPriceModel.empty()]
  ];

  Future<void> fetchCommodityPrices() async {
    if (data.isLeft || data.right.cotacoes?.length == 1) {
      loading = true;
      notifyListeners();
    }

    final response = await CommodityPriceRepository.getResponseCommodityPrice();

    if (response.isRight) {
      data = response;

      final count = response.right.cotacoes?.length ?? 0;
      List<Group> newGroup = [];

      for (var index = 0; index < count; index++) {
        final item = response.right.cotacoes![index];

        if (item.bolsa != null) {
          if (item.bolsa!.isNotEmpty) {
            newGroup.add(Group(item.bolsa!));
          } else {
            if (item.contrato != null) {
              if (item.contrato == "BRL-AE") {
                final dollar = Group("Dólar");
                dollar.marketPrices = [item];
                newGroup.add(dollar);
                continue;
              }
            }
            newGroup[newGroup.length - 1].marketPrices.add(item);
          }
        }
      }

      if (group.length == newGroup.length) {
        for (var index = 0; index < group.length; index++) {
          group[index].marketPrices = newGroup[index].marketPrices;
        }
      } else {
        group = newGroup;
      }
    } else {
      data = Left(Exception("Erro ao buscar os preços"));
    }

    loading = false;
    notifyListeners();
  }
}

class Group {
  String title;
  List<MarketPriceModel> marketPrices = [];

  Group(this.title);
}
