import 'package:cocatrel/models/dashboard_quote.dart';
import 'package:cocatrel/models/dashboard_quote_date.dart';
import 'package:cocatrel/models/dashboard_quote_variation.dart';

class DashboardQuotes {
  final String date;
  final String cooperateName;
  final List<DashboardQuote> quotes;
  final List<DashboardQuoteVariation> quotesVariations;
  final List<DashboardQuoteDate> quotesDates;

  DashboardQuotes({
    required this.date,
    required this.cooperateName,
    required this.quotes,
    required this.quotesVariations,
    required this.quotesDates,
  });

  factory DashboardQuotes.fromJson(Map<String, dynamic> json) {
    return DashboardQuotes(
      date: json['DataCotacao'],
      cooperateName: json['NomeCooperado'],
      quotes: (json['CotacaoCafe'] as List)
          .map((e) => DashboardQuote.fromJson(e))
          .toList(),
      quotesVariations: (json['VariacaoCotacao'] as List)
          .map((e) => DashboardQuoteVariation.fromJson(e))
          .toList(),
      quotesDates: (json['DatasCotacao'] as List)
          .map((e) => DashboardQuoteDate.fromJson(e))
          .toList(),
    );
  }
}
