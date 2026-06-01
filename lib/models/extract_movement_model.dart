class ExtractMovement {
  final double? initialBalanceBags;
  final double? initialBalanceKg;
  final double? periodEntries;
  final double? periodExits;
  final double? finalBalance;
  final List<Movement>? movementsList;

  ExtractMovement({
    this.initialBalanceBags,
    this.initialBalanceKg,
    this.periodEntries,
    this.periodExits,
    this.finalBalance,
    this.movementsList,
  });

  // Factory method to create an ExtractMovement from a JSON map
  factory ExtractMovement.fromJson(Map<String, dynamic> json) {
    var movementListJson = json['ListaMovimentos'] as List<dynamic>?;
    List<Movement>? movementList = movementListJson
        ?.map((movement) => Movement.fromJson(movement))
        .toList();

    return ExtractMovement(
      initialBalanceBags: (json['SaldoInicial_sacas'] as num?)?.toDouble(),
      initialBalanceKg: (json['SaldoInicial_kg'] as num?)?.toDouble(),
      periodEntries: (json['EntradasPeriodo'] as num?)?.toDouble(),
      periodExits: (json['SaidasPeriodo'] as num?)?.toDouble(),
      finalBalance: (json['SaldoFinal'] as num?)?.toDouble(),
      movementsList: movementList,
    );
  }

  // Method to convert an ExtractMovement object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'SaldoInicial_sacas': initialBalanceBags,
      'SaldoInicial_kg': initialBalanceKg,
      'EntradasPeriodo': periodEntries,
      'SaidasPeriodo': periodExits,
      'SaldoFinal': finalBalance,
      'ListaMovimentos':
          movementsList?.map((movement) => movement.toJson()).toList(),
    };
  }
}

class Movement {
  final String? movementDate;
  final String? history;
  final String? typeES;
  final double? quantityBags;
  final double? balanceBags;
  final String? lot;
  final String? invoice;
  final String? crop;
  final String? standard;
  final String? sieve;
  final double? percentageBreak;
  final String? drink;
  final String? certificate;
  final String? customized;
  final double? score;
  final double? percentageDry;
  final String? dryingType;
  final String? farmRegistrationNumber;
  final String? farmName;

  Movement({
    this.movementDate,
    this.history,
    this.typeES,
    this.quantityBags,
    this.balanceBags,
    this.lot,
    this.invoice,
    this.crop,
    this.standard,
    this.sieve,
    this.percentageBreak,
    this.drink,
    this.certificate,
    this.customized,
    this.score,
    this.percentageDry,
    this.dryingType,
    this.farmRegistrationNumber,
    this.farmName,
  });

  // Factory method to create a Movement from a JSON map
  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      movementDate: json['DataMovimento'],
      history: json['Historico'],
      typeES: json['FlgES'],
      quantityBags: (json['QtdSacas'] as num?)?.toDouble(),
      balanceBags: (json['SaldoSacas'] as num?)?.toDouble(),
      lot: json['Lote'],
      invoice: json['NF'],
      crop: json['Safra'],
      standard: json['Padrao'],
      sieve: json['Peneira'],
      percentageBreak: (json['PerQuebra'] as num?)?.toDouble(),
      drink: json['Bebida'],
      certificate: json['Certificado'],
      customized: json['Personalizado'],
      score: (json['Pontuacao'] as num?)?.toDouble(),
      percentageDry: (json['PerSeca'] as num?)?.toDouble(),
      dryingType: json['TipoSeca'],
      farmRegistrationNumber: json['NumInscricaoFazenda'],
      farmName: json['NomeFazenda'],
    );
  }

  // Method to convert a Movement object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'DataMovimento': movementDate,
      'Historico': history,
      'FlgES': typeES,
      'QtdSacas': quantityBags,
      'SaldoSacas': balanceBags,
      'Lote': lot,
      'NF': invoice,
      'Safra': crop,
      'Padrao': standard,
      'Peneira': sieve,
      'PerQuebra': percentageBreak,
      'Bebida': drink,
      'Certificado': certificate,
      'Personalizado': customized,
      'Pontuacao': score,
      'PerSeca': percentageDry,
      'TipoSeca': dryingType,
      'NumInscricaoFazenda': farmRegistrationNumber,
      'NomeFazenda': farmName,
    };
  }
}
