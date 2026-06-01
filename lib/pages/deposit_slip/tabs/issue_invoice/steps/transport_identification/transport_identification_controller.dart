import 'package:cocatrel/models/coffee_entry_model.dart';
import 'package:cocatrel/pages/deposit_slip/models/deposit_slip_model.dart';
import 'package:flutter/material.dart';

class TransportIdentificationController extends ChangeNotifier {
  final plateTextController = TextEditingController();
  final carrierNameTextController = TextEditingController();
  final documentNumberTextController = TextEditingController();
  final driverTextController = TextEditingController();
  final transportIdentificationFormKey = GlobalKey<FormState>();

  TransportIdentificationController(this.depositSlip);

  bool validateForm() {
    if (transportIdentificationFormKey.currentState!.validate()) {
      depositSlip.plate = plateTextController.text;
      depositSlip.carrierName = carrierNameTextController.text;
      depositSlip.documentNumber = documentNumberTextController.text;
      depositSlip.driverName = driverTextController.text;

      if (depositSlip.meansTransportation) {
        depositSlip.carrierName = null;
        depositSlip.documentNumber = null;
      } else if (!depositSlip.meansTransportation ||
          depositSlip.vehicleType == VehicleType.tractor) {
        depositSlip.carrier = null;
      }
      if (depositSlip.vehicleType == VehicleType.licensed) {
        depositSlip.tractorBrand = null;
        depositSlip.driverName = null;
      } else {
        depositSlip.uf = null;
      }

      return true;
    }

    return false;
  }

  DepositSlip depositSlip;

  bool get enablePlate {
    return (depositSlip.carrier?.vehiclePlate ?? '').isEmpty &&
        depositSlip.vehicleType != VehicleType.tractor;
  }

  void setCurrentCarrier(CarrierModel? value) {
    depositSlip.carrier = value;
    plateTextController.text = value?.vehiclePlate ?? '';
    changeCurrentUf(value?.carrierUf ?? '');
    notifyListeners();
  }

  void setCurrentTractor(String? value) {
    depositSlip.tractorBrand = value;
    notifyListeners();
  }

  void changeSelectMeansTransport(bool value) {
    if (value != depositSlip.meansTransportation) {
      depositSlip.meansTransportation = value;

      changeCurrentUf(null);
      setCurrentCarrier(null);

      notifyListeners();
    }
  }

  void changeVehicleType(VehicleType value) {
    if (value != depositSlip.vehicleType) {
      depositSlip.vehicleType = value;

      changeCurrentUf(null);
      setCurrentCarrier(null);
      setCurrentTractor(null);

      if (value == VehicleType.tractor) {
        plateTextController.text = 'TRATOR';
      }

      notifyListeners();
    }
  }

  void changeCurrentUf(String? value) {
    depositSlip.uf = value;
    notifyListeners();
  }
}
