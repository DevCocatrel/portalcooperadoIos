import 'package:cocatrel/models/dashboard_commoditie.dart';

class DashboardCommodities {
  final String dateHourCommoditie;
  final List<DashboardCommoditie> commodities;

  DashboardCommodities({
    required this.dateHourCommoditie,
    required this.commodities,
  });

  factory DashboardCommodities.fromJson(Map<String, dynamic> json) {
    return DashboardCommodities(
      dateHourCommoditie: json['DataHoraCotacao'],
      commodities: (json['Cotacoes'] as List)
          .map((e) => DashboardCommoditie.fromJson(e))
          .toList(),
    );
  }
}
