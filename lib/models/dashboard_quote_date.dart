class DashboardQuoteDate {
  final String date;

  DashboardQuoteDate({
    required this.date,
  });

  factory DashboardQuoteDate.fromJson(Map<String, dynamic> json) {
    return DashboardQuoteDate(
      date: json['DataCotacao'],
    );
  }
}
