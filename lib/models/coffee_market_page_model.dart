class CoffeeMarketPageModel {
  final String quoteDate;
  final String cooperateName;
  final List<CoffeeMarketQuoteItemModel> quotes;
  final List<CoffeeMarketQuoteVariationItemModel> variations;
  final List<CoffeeMarketQuoteDateItemModel> dates;

  CoffeeMarketPageModel({
    required this.quoteDate,
    required this.cooperateName,
    required this.quotes,
    required this.variations,
    required this.dates,
  });

  factory CoffeeMarketPageModel.fromJson(Map<String, dynamic> json) {
    return CoffeeMarketPageModel(
      quoteDate: json['DataCotacao'],
      cooperateName: json['NomeCooperado'],
      quotes: (json['CotacaoCafe'] as List)
          .map((quote) => CoffeeMarketQuoteItemModel.fromJson(quote))
          .toList(),
      variations: (json['VariacaoCotacao'] as List).map((variation) {
        return CoffeeMarketQuoteVariationItemModel.fromJson(variation);
      }).toList(),
      dates: (json['DatasCotacao'] as List)
          .map((date) => CoffeeMarketQuoteDateItemModel.fromJson(date))
          .toList(),
    );
  }
}

class CoffeeMarketQuoteDateItemModel {
  final String date;

  DateTime get dateTime {
    final dateFormatted = date.split('/').reversed.join('-');

    return DateTime.parse(dateFormatted);
  }

  CoffeeMarketQuoteDateItemModel({
    required this.date,
  });

  factory CoffeeMarketQuoteDateItemModel.fromJson(Map<String, dynamic> json) {
    return CoffeeMarketQuoteDateItemModel(
      date: json['DataCotacao'],
    );
  }
}

class CoffeeMarketQuoteVariationItemModel {
  final String date;
  final double price;
  final String percentage;

  CoffeeMarketQuoteVariationItemModel({
    required this.date,
    required this.price,
    required this.percentage,
  });

  factory CoffeeMarketQuoteVariationItemModel.fromJson(
      Map<String, dynamic> json) {
    return CoffeeMarketQuoteVariationItemModel(
      date: json['DataCotacao'],
      price: json['ValorCotacao'],
      percentage: json['Catacao'],
    );
  }
}

class CoffeeMarketQuoteItemModel {
  final String name;
  final String date;
  final double price;
  final String backgroundColor;
  final String textColor;
  final String percentage;
  final double priceWithCMS;

  CoffeeMarketQuoteItemModel(
      {required this.name,
      required this.date,
      required this.price,
      required this.backgroundColor,
      required this.textColor,
      required this.percentage,
      required this.priceWithCMS});

  factory CoffeeMarketQuoteItemModel.fromJson(Map<String, dynamic> json) {
    return CoffeeMarketQuoteItemModel(
      name: json['Classificacao'],
      date: json['DataCotacao'],
      price: json['ValorCotacao'],
      backgroundColor: json['CodigoCorFundo'],
      textColor: json['CodigoCorTexto'],
      percentage: json['Catacao'],
      priceWithCMS: json['ValorCotacaoComICMS'],
    );
  }
}
