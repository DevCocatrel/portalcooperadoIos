class DashboardQuote {
  final String classification;
  final String date;
  final double price;
  final String backgroundColor;
  final String textColor;
  final String percentage;

  DashboardQuote({
    required this.classification,
    required this.date,
    required this.price,
    required this.backgroundColor,
    required this.textColor,
    required this.percentage,
  });

  factory DashboardQuote.fromJson(Map<String, dynamic> json) {
    return DashboardQuote(
      classification: json['Classificacao'],
      date: json['DataCotacao'],
      price: json['ValorCotacao'],
      backgroundColor: json['CodigoCorFundo'],
      textColor: json['CodigoCorTexto'],
      percentage: json['Catacao'],
    );
  }
}
