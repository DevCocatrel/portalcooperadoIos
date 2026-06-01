import 'package:cocatrel/models/lot_model.dart';

class CoffeeExtractFromFarmModel {
  double? totalBagsReceived; // totalSacasEntrada
  double? totalBagsBalance; // totalSacasSaldo
  double? totalBagsBlocked; // totalSacasBloqueadas
  double? totalBagsAuthorized; // totalSacasAutorizadas
  double? totalBagsAvailable; // totalSacasDisponiveis
  double? totalICMS; // totalICMS
  double? totalExpenses; // totalDespesas
  double? totalCustomized; // totalPersonalizado
  double? totalINSS; // totalINSS
  double? totalCapital; // totalCapital
  double? totalNet; // totalLiquido

  List<LotModel>? lotList;

  CoffeeExtractFromFarmModel(
      {this.totalBagsReceived,
      this.totalBagsBalance,
      this.totalBagsBlocked,
      this.totalBagsAuthorized,
      this.totalBagsAvailable,
      this.totalICMS,
      this.totalExpenses,
      this.totalCustomized,
      this.totalINSS,
      this.totalCapital,
      this.lotList,
      this.totalNet});

  CoffeeExtractFromFarmModel.fromJson(Map<String, dynamic> json) {
    totalBagsReceived = (json['totalSacasEntrada'] as num?)?.toDouble();
    totalBagsBalance = (json['totalSacasSaldo'] as num?)?.toDouble();
    totalBagsBlocked = (json['totalSacasBloqueadas'] as num?)?.toDouble();
    totalBagsAuthorized = (json['totalSacasAutorizadas'] as num?)?.toDouble();
    totalBagsAvailable = (json['totalSacasDisponiveis'] as num?)?.toDouble();
    totalICMS = (json['totalICMS'] as num?)?.toDouble();
    totalExpenses = (json['totalDespesas'] as num?)?.toDouble();
    totalCustomized = (json['totalPersonalizado'] as num?)?.toDouble();
    totalINSS = (json['totalINSS'] as num?)?.toDouble();
    totalCapital = (json['totalCapital'] as num?)?.toDouble();
    totalNet = (json['totalLiquido'] as num?)?.toDouble();
    if (json['lancamentosCafe'] != null && json['lancamentosCafe'] is List) {
      lotList = (json['lancamentosCafe'] as List)
          .map((data) => LotModel.fromJson(data))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalSacasEntrada'] = totalBagsReceived;
    data['totalSacasSaldo'] = totalBagsBalance;
    data['totalSacasBloqueadas'] = totalBagsBlocked;
    data['totalSacasAutorizadas'] = totalBagsAuthorized;
    data['totalSacasDisponiveis'] = totalBagsAvailable;
    data['totalICMS'] = totalICMS;
    data['totalDespesas'] = totalExpenses;
    data['totalPersonalizado'] = totalCustomized;
    data['totalINSS'] = totalINSS;
    data['totalCapital'] = totalCapital;
    data['totalLiquido'] = totalNet;
    return data;
  }
}
