class MarketPriceModel {
  String? bolsa;
  String? contrato;
  String? descContrato;
  String? ultimo;
  String? cotacao;
  String? dif;
  String? percentual;
  String? fechamento;
  String? fechamentoAnterior;
  String? maximo;
  String? minimo;
  String? compra;
  String? venda;
  String? abertura;
  String? posicao;

  MarketPriceModel(
      {this.bolsa,
      this.contrato,
      this.descContrato,
      this.cotacao,
      this.ultimo,
      this.dif,
      this.percentual,
      this.fechamento,
      this.fechamentoAnterior,
      this.maximo,
      this.minimo,
      this.compra,
      this.venda,
      this.abertura,
      this.posicao});

  MarketPriceModel.empty();

  MarketPriceModel.fromJson(Map<String, dynamic> json) {
    bolsa = json['Bolsa'];
    contrato = json['Contrato'];
    descContrato = json['DescContrato'];
    cotacao = json['Cotacao'];
    dif = json['Dif'];
    percentual = json['Percentual'];
    fechamento = json['Fechamento'];
    fechamentoAnterior = json['FechamentoAnterior'];
    maximo = json['Maximo'];
    minimo = json['Minimo'];
    compra = json['Compra'];
    venda = json['Venda'];
    abertura = json['Abertura'];
    posicao = json['Posicao'];
    ultimo = json['Ultimo'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Bolsa'] = bolsa;
    data['Contrato'] = contrato;
    data['DescContrato'] = descContrato;
    data['Cotacao'] = cotacao;
    data['Dif'] = dif;
    data['Percentual'] = percentual;
    data['Fechamento'] = fechamento;
    data['FechamentoAnterior'] = fechamentoAnterior;
    data['Maximo'] = maximo;
    data['Minimo'] = minimo;
    data['Compra'] = compra;
    data['Venda'] = venda;
    data['Abertura'] = abertura;
    data['Posicao'] = posicao;
    data['Ultimo'] = ultimo;
    return data;
  }
}
