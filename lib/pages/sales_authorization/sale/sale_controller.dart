import 'dart:typed_data';

import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/providers/auth.dart';
import 'package:cocatrel/models/authorization_sale_page_model.dart';
import 'package:cocatrel/pages/sales_authorization/lotsByFarmId/list_lots_by_farm_id_controller.dart';
import 'package:cocatrel/repositories/authorization_sales_repository.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double roundToTwoDecimals(double? value) {
  if (value == null) return 0;

  return (value * 100).round() / 100;
}

class SalePageController extends ChangeNotifier {
  final quickMoneyInputController = TextEditingController();
  final CurrencyTextInputFormatter currencyFormatter =
      CurrencyTextInputFormatter.currency(
    decimalDigits: 2,
    symbol: 'R\$',
    locale: 'pt_BR',
  );
  final quickMoneyInputControllerNode = FocusNode();

  final double openTitles;
  final List<AuthorizationSaleBankAccountModel> bankAccounts;
  final AuthorizationSaleFarmBalanceModel farm;
  final List<AuthorizationItem> batches;
  final int _maxSteps = 3;
  double totalFixedPrice = 0;
  double totalNetUnitPrice = 0;
  double maxQuickMoney = 0;
  bool isAllowedToUseQuickMoney = false;

  int currentStep = 0;
  String? applicantName;
  AuthorizationSaleBankAccountModel? selectedAccount;
  AuthorizationSaleBankAccountModel? selectedAccountQuickMoney;
  bool isQuickMoney = false;

  String? get showSelectedAccountQuickMoney {
    if (selectedAccountQuickMoney != null) {
      final splicedId = selectedAccountQuickMoney!.id.split(';');
      return "${splicedId[2]} - ${selectedAccountQuickMoney!.bank}";
    }
    return null;
  }

  String? get showSelectedAccount {
    if (selectedAccount != null) {
      final splicedId = selectedAccount!.id.split(';');
      return "${splicedId[2]} - ${selectedAccount!.bank}";
    }
    return null;
  }

  SalePageController({
    required this.farm,
    required this.batches,
    required this.bankAccounts,
    required this.openTitles,
  }) {
    _calculate();
  }

  void setQuickMoney(bool value) {
    isQuickMoney = value;
    notifyListeners();
  }

  void setApplicantName(String name) {
    applicantName = name;
    notifyListeners();
  }

  void setSelectedAccount(AuthorizationSaleBankAccountModel? account) {
    selectedAccount = account;
    notifyListeners();
  }

  void setSelectedAccountQuickMoney(
      AuthorizationSaleBankAccountModel? account) {
    selectedAccountQuickMoney = account;
    notifyListeners();
  }

  void nextStep() {
    if (currentStep >= _maxSteps) return;

    currentStep++;
    notifyListeners();
  }

  void setStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  void previousStep() {
    if (currentStep == 0) return;

    currentStep--;
    notifyListeners();
  }

  void setBankAccounts(List<AuthorizationSaleBankAccountModel> accounts) {
    bankAccounts.clear();
    bankAccounts.addAll(accounts);
    notifyListeners();
  }

  void _calculate() {
    var sumOfFixedPrice = batches.fold<double>(
      0,
      (previousValue, element) {
        if (element.fixedPrice == null) {
          return previousValue;
        }

        return previousValue + (element.fixedPrice ?? 0);
      },
    );

    var sumOfNetUnitPrice = batches.fold<double>(0, (previousValue, element) {
      if (element.fixedPrice == null) {
        return previousValue + element.information.netUnitPrice;
      }

      return previousValue;
    });

    var sumOfBagsNetUnitPrice =
        batches.fold<double>(0, (previousValue, element) {
      if (element.fixedPrice == null) {
        return previousValue + element.bags;
      }

      return previousValue;
    });

    var sumOfBagsFixedPrice = batches.fold<double>(0, (previousValue, element) {
      if (element.fixedPrice != null) {
        return previousValue + element.bags;
      }

      return previousValue;
    });

    totalFixedPrice = sumOfFixedPrice * sumOfBagsFixedPrice;
    totalNetUnitPrice = sumOfNetUnitPrice * sumOfBagsNetUnitPrice;
    maxQuickMoney = double.parse(
        ((totalNetUnitPrice * 0.7) - openTitles).toStringAsFixed(2));
    isAllowedToUseQuickMoney = sumOfBagsNetUnitPrice > 0;

    notifyListeners();
  }

  Future<Uint8List?> completeSale(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    var json = {
      'Matricula': auth.user?.registration,
      'InscricaoFazenda': farm.inscription,
      'NomeSolicitante': applicantName,
      'ContaPagamento': selectedAccount?.id,
      'ContaAdiantamento': selectedAccountQuickMoney?.id ?? "",
      'ValorMaxAdiantamento': roundToTwoDecimals(maxQuickMoney),
      'ValorAdiantamento': currencyFormatter
          .getUnformattedValue()
          .toDouble()
          .toString()
          .replaceAll('.', ','),
      'ValorDoMovimento': roundToTwoDecimals(totalNetUnitPrice),
      'ValorDoMovimentoPF': roundToTwoDecimals(totalFixedPrice),
      'TemAdiantamento': isQuickMoney,
      'LotesAutorizadosParaVenda': batches.map((batch) {
        var isFixedPrice = batch.fixedPrice != null;

        var unitPrice = roundToTwoDecimals(
          isFixedPrice ? batch.fixedPrice : batch.information.netUnitPrice,
        );

        var totalPrice = roundToTwoDecimals(
          isFixedPrice
              ? batch.fixedPrice! * batch.bags
              : batch.information.netUnitPrice * batch.bags,
        );

        var entryDate = batch.information.entryDate;
        var formattedEntryDate = DateTime.parse(entryDate).toIso8601String();

        return {
          'Lote': batch.information.batch,
          'CodigoPadrao': batch.information.standardClassification,
          "TipoPreco": batch.modality == CoffeeModality.market ? "M" : "P",
          "QtdSacas": batch.bags,
          "QtdKg": batch.weight,
          "ValorUnitario": unitPrice,
          "ValorTotal": totalPrice,
          "LoteDataEntrada": formattedEntryDate,
          "BOM_BARR_BEB": batch.information.goodBarrelDrink,
          "NOM_AMOSTRA": batch.information.sampleName
        };
      }).toList(),
    };

    var saleResult = await AuthorizationSalesRepository.completeSale(json);

    if (saleResult.isRight) {
      var authorizationNumber = saleResult.right;

      var receiptResult =
          await AuthorizationSalesRepository.authorizationReceiptDownload(
        type: AuthorizationFileType.pdf,
        authorizationNumber: authorizationNumber,
      );

      if (receiptResult.isRight) {
        await FileSaver.instance.saveAs(
          name: "${authorizationNumber}_recibo_autorizacao_venda",
          bytes: receiptResult.right,
          mimeType: MimeType.pdf,
          fileExtension: "pdf",
        );

        successSnackBar("Autorização de venda realizada com sucesso");

        return receiptResult.right;
      } else {
        errorSnackBar("Erro ao salvar o arquivo");
        return null;
      }
    } else {
      errorSnackBar("Erro ao criar a autorização de venda");
      return null;
    }
  }
}
