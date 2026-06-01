class OrderDetailsAuthorizationModel {
  final String batch;
  final String harvest;
  final String entryDate;
  final double bags;
  final double price;
  final String quote;
  final String picking;
  final String sieve;
  final String dry;
  final String certifier;
  final String procDry;

  OrderDetailsAuthorizationModel({
    required this.batch,
    required this.harvest,
    required this.entryDate,
    required this.bags,
    required this.price,
    required this.quote,
    required this.picking,
    required this.sieve,
    required this.dry,
    required this.certifier,
    required this.procDry,
  });

  factory OrderDetailsAuthorizationModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsAuthorizationModel(
      batch: json['Lote'],
      harvest: json['Safra'],
      entryDate: json['DataEntrada'],
      bags: json['Sacas'],
      price: json['Preco'],
      quote: json['Padrao'],
      picking: json['Catacao'],
      sieve: json['Peneira'],
      dry: json['Seca'],
      certifier: json['Certificador'],
      procDry: json['ProcSeca'],
    );
  }
}
