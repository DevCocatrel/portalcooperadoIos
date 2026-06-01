import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/models/authorization_sale_batches_model.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/list_lots_by_farm_id_controller.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BatchItemController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  CoffeeModality? coffeeModality;
  final bagsInputController = TextEditingController();
  final bagsInputControllerNode = FocusNode();

  final weightInputController = TextEditingController();
  final weightInputControllerNode = FocusNode();

  final priceInputController = TextEditingController();
  final priceInputControllerNode = FocusNode();

  final CurrencyTextInputFormatter currencyFormatter =
      CurrencyTextInputFormatter.currency(
    decimalDigits: 2,
    symbol: 'R\$',
    locale: 'pt_BR',
  );

  void setCoffeeModality(CoffeeModality? coffeeModality) {
    this.coffeeModality = coffeeModality;

    notifyListeners();
  }

  void clearInputs() {
    bagsInputController.clear();
    weightInputController.clear();
    priceInputController.clear();

    notifyListeners();
  }

  void addBatchItemToCard(
    BuildContext context,
    AuthorizationSaleBatchesModel batch,
  ) {
    try {
      final batchId = batch.batch;
      final ListLotsByFarmIdController listController =
          Provider.of<ListLotsByFarmIdController>(context, listen: false);

      if (!formKey.currentState!.validate()) {
        return;
      }

      var itemInList = listController.getItemByBatch(batchId);

      if (itemInList != null) {
        successSnackBar("Lote atualizado no carrinho");

        listController.removeByBatch(batchId);
      }

      var fixedPrice = coffeeModality == CoffeeModality.prefix
          ? currencyFormatter.getUnformattedValue().toDouble()
          : null;

      listController.addItem(
        information: batch,
        bags: double.parse(bagsInputController.text),
        weight: double.parse(weightInputController.text),
        modality:
            fixedPrice != null ? CoffeeModality.prefix : CoffeeModality.market,
        fixedPrice: fixedPrice,
      );
    } catch (e) {
      errorSnackBar("Erro ao adicionar lote ao carrinho");
    }
  }
}
