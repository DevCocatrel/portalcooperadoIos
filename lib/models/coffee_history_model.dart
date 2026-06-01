class CoffeeHistoryModel {
  final String date;
  final double price;
  final String percentage;

  CoffeeHistoryModel({
    required this.date,
    required this.price,
    required this.percentage,
  });

  factory CoffeeHistoryModel.fromJson(Map<String, dynamic> json) {
    return CoffeeHistoryModel(
      date: json['DataCotacao'],
      price: json['ValorCotacao'],
      percentage: json['Catacao'],
    );
  }
}
