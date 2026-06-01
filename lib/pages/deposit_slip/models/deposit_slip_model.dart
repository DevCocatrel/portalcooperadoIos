import 'package:cocatrel/models/coffee_entry_model.dart';
import 'package:cocatrel/models/deposit_farm_list_model.dart';
import 'package:intl/intl.dart';

enum VehicleType {
  licensed,
  tractor,
}

enum TypeCoffee { coffee, passOrChoose }

enum DryProcess { normal, peeledCherry }

class DepositSlip {
  DepositSlip({
    this.cooperatorName,
    this.userRegistration,
    this.farm,
  });
  String? cooperatorName;
  String? userRegistration;

  double? coffeePrice;

  // Fazenda
  Farm? farm;
  String? farmCertificates;
  String? farmCertificateCode;

  // transporte
  bool meansTransportation = true;
  VehicleType vehicleType = VehicleType.licensed;
  String? uf;
  CarrierModel? carrier;
  String? plate;
  String? carrierName;
  String? documentNumber; //CPF/CNPJ
  String? driverName;
  String? tractorBrand;

  // informações cafe
  TypeCoffee typeCoffee = TypeCoffee.coffee;
  DryProcess dryProcess = DryProcess.normal;
  bool personalized = true;
  double quantityBags = .0;
  double quantityKgs = .0;
  double totalValue = .0;

  // delivery
  WarehouseModel? warehouse;
  PackagingModel? packaging;
  String? emailNFE;

  Map<String, dynamic> get toJson {
    return {
      // Cooperado
      'NomeCooperado': cooperatorName,
      'Matricula': int.parse(userRegistration ?? '0'),
      // Fazenda
      'NomeFazenda': farm?.farmName,
      'InscricaoFazenda': farm?.registrationNumber,
      'DataEmissao': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      // TRANSPORTADOR
      'IndentificaTransportador': meansTransportation ? 0 : 1,
      if (meansTransportation) ...{
        'TranspEscTipoVeiculo': vehicleType == VehicleType.licensed ? "0" : '1',
        'TranspEscCodigoTransportador': carrier?.carrierCode?.toString() ?? '',
        'TranspEscPlaca': plate,
        if (vehicleType == VehicleType.tractor) ...{
          'TranspEscTratorPlaca': 'TRATOR',
          'TranspEscTratorMotorista': driverName,
          'TranspEscTratorMarca': tractorBrand,
        } else ...{
          'TranspEscUfPlaca': uf,
        }
      },

      if (!meansTransportation) ...{
        'TranspInfNomeRazao': carrierName,
        'TranspInfCnpjCpf': documentNumber,
        'TranspInfTipoVeiculo': vehicleType == VehicleType.licensed ? 0 : 1,
        if (vehicleType == VehicleType.tractor) ...{
          'TranspInfTratorPlaca': plate,
          'TranspInfTratorMotorista': driverName,
          'TranspInfTratorMarca': tractorBrand,
        } else ...{
          'TranspInfPlaca': plate,
          'TranspInfUfPlaca': uf,
        },
      },
      // CAFE
      'TipoCafe': typeCoffee == TypeCoffee.coffee ? '0' : '1',
      'ProcessoSeca': dryProcess == DryProcess.normal ? 'N' : 'C',
      'Personalizado': personalized ? 'S' : 'N',
      'Certificados': farmCertificateCode,
      'QuantidadeSacas': quantityBags.toInt(),
      'QuantidadeSacasKg': quantityKgs.toInt(),
      'ValorTotal': totalValue.toInt(),

      //Entrega
      'LocalEntrega': warehouse?.warehouseCode?.toString() ?? '',
      'EmbalagemEntrega': packaging?.packagingCode,
      'EmailEnvioNFe': emailNFE,
    };
  }
}
