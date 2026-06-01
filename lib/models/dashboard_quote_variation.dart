class DashboardQuoteVariation {
  final String date;
  final double price;

  DashboardQuoteVariation({
    required this.date,
    required this.price,
  });

  factory DashboardQuoteVariation.fromJson(Map<String, dynamic> json) {
    return DashboardQuoteVariation(
      date: json['DataCotacao'],
      price: double.parse(json['ValorCotacao']),
    );
  }
}
