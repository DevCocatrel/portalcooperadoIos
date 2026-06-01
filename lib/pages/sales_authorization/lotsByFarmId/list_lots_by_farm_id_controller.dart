import 'package:cocatrel/models/authorization_sale_batches_model.dart';
import 'package:cocatrel/models/authorization_sale_page_model.dart';
import 'package:flutter/material.dart';

enum CoffeeModality { market, prefix }

String convertModalityToString(CoffeeModality modality) {
  switch (modality) {
    case CoffeeModality.market:
      return 'Mercado do dia';
    case CoffeeModality.prefix:
      return 'Preço prefixado';
  }
}

class AuthorizationItem {
  final AuthorizationSaleBatchesModel information;
  final CoffeeModality modality;
  final double bags;
  final double weight;
  final double? fixedPrice;

  AuthorizationItem({
    required this.information,
    required this.bags,
    required this.weight,
    required this.modality,
    this.fixedPrice,
  });
}

class ListLotsByFarmIdController extends ChangeNotifier {
  double openTitles;
  AuthorizationSaleFarmBalanceModel farm;
  List<AuthorizationItem> batches = [];

  ListLotsByFarmIdController({
    required this.farm,
    required this.openTitles,
  });

  void addItem({
    required AuthorizationSaleBatchesModel information,
    required double bags,
    required double weight,
    required CoffeeModality modality,
    double? fixedPrice,
  }) {
    batches.add(AuthorizationItem(
      information: information,
      bags: bags,
      weight: weight,
      modality: modality,
      fixedPrice: fixedPrice,
    ));

    notifyListeners();
  }

  void clear() {
    batches.clear();

    notifyListeners();
  }

  AuthorizationItem? getItemByBatch(String batch) {
    try {
      return batches.firstWhere(
        (element) => element.information.batch == batch,
      );
    } catch (e) {
      return null;
    }
  }

  void removeByBatch(String batch) {
    try {
      var item = getItemByBatch(batch);

      if (item == null) {
        return;
      }

      batches.removeWhere((element) => element.information.batch == batch);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
