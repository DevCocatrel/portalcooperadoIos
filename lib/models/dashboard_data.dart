import 'package:cocatrel/models/dashboard_balance_per_quote_classification.dart';
import 'package:cocatrel/models/dashboard_harvest.dart';
import 'package:cocatrel/models/dashboard_balance_by_farm.dart';
import 'package:cocatrel/models/dashboard_certifies.dart';

class DashboardData {
  final String leftOversYear;
  final double leftoversBalance;
  final double leftoversAvailableBalance;
  final double soyBalanceKg;
  final double cornBalanceKg;
  final double soyBalanceBags;
  final double cornBalanceBags;
  final String cooperatorName;
  final double openTitles;
  final int authorizationsSalesPending;
  final double totalTitlesOpen;
  final double balanceAccountCapital;
  final String balanceAccountCapitalDate;
  final double balanceCashBackA;
  final double balanceCashBackB;
  final double balanceCashBackC;
  final String balanceCashBackDate;
  final double balanceCoffeeBags;
  final String balanceCafeBagsDate;
  final double balanceCafeBlocked;
  final String balanceCafeBlockedDate;
  final int joinedCashBack;
  final List<DashboardHarvest> harvests;
  final List<DashboardHarvest> balanceHarvests;
  final List<DashboardBalancePerQuoteClassificationModel>
      balancePerQuoteClassification;
  final List<DashboardBalanceByFarm> balanceByFarm;
  final List<DashboardCertifies> certifies;

  DashboardData({
    required this.leftOversYear,
    required this.leftoversBalance,
    required this.leftoversAvailableBalance,
    required this.soyBalanceKg,
    required this.cornBalanceKg,
    required this.soyBalanceBags,
    required this.cornBalanceBags,
    required this.cooperatorName,
    required this.openTitles,
    required this.authorizationsSalesPending,
    required this.totalTitlesOpen,
    required this.balanceAccountCapital,
    required this.balanceAccountCapitalDate,
    required this.balanceCashBackA,
    required this.balanceCashBackB,
    required this.balanceCashBackC,
    required this.balanceCashBackDate,
    required this.balanceCoffeeBags,
    required this.balanceCafeBagsDate,
    required this.balanceCafeBlocked,
    required this.balanceCafeBlockedDate,
    required this.joinedCashBack,
    required this.harvests,
    required this.balanceHarvests,
    required this.balancePerQuoteClassification,
    required this.balanceByFarm,
    required this.certifies,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      leftOversYear: json['SobrasAno'],
      leftoversBalance: json['SobrasSaldo'],
      leftoversAvailableBalance: json['SobrasSaldoDisponivel'],
      soyBalanceKg: json['SaldoSojaKg'],
      cornBalanceKg: json['SaldoMilhoKg'],
      soyBalanceBags: json['SaldoSojaSacas'],
      cornBalanceBags: json['SaldoMilhoSacas'],
      cooperatorName: json['NomeCooperado'],
      openTitles: json['TitulosABerto'],
      authorizationsSalesPending: json['AutorizacoesVendasPendentes'],
      totalTitlesOpen: json['TotalTitulosAberto'],
      balanceAccountCapital: double.tryParse(json['SaldoContaCapital']) ?? 0.0,
      balanceAccountCapitalDate: json['SaldoContaCapitalData'],
      balanceCashBackA: json['SaldoCashBack_a'],
      balanceCashBackB: json['SaldoCashBack_b'],
      balanceCashBackC: json['SaldoCashBack_c'],
      balanceCashBackDate: json['SaldoCashBackData'],
      balanceCoffeeBags: json['SaldoCafe_sacas'],
      balanceCafeBagsDate: json['SaldoCafe_sacasData'],
      balanceCafeBlocked: json['SaldoCafe_bloqueados'],
      balanceCafeBlockedDate: json['SaldoCafe_bloqueadosData'],
      joinedCashBack: json['AderiuCashBack'],
      harvests: (json['EntradaSafras'] as List)
          .map((e) => DashboardHarvest.fromJson(e))
          .toList(),
      balanceHarvests: (json['SaldoSafras'] as List)
          .map((e) => DashboardHarvest.fromJson(e))
          .toList(),
      balancePerQuoteClassification: (json['SaldoBebida'] as List)
          .map(
            (e) => DashboardBalancePerQuoteClassificationModel.fromJson(e),
          )
          .toList(),
      balanceByFarm: (json['SaldosPorFazenda'] as List)
          .map((e) => DashboardBalanceByFarm.fromJson(e))
          .toList(),
      certifies: (json['Certificados'] as List)
          .map((e) => DashboardCertifies.fromJson(e))
          .toList(),
    );
  }
}
