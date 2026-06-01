import 'package:cocatrel/common/widgets/snack_bar/default_snack_bar.dart';
import 'package:cocatrel/core/app/app.dart';
import 'package:cocatrel/models/ombudsman_options_model.dart';
import 'package:cocatrel/models/option_model.dart';
import 'package:cocatrel/repositories/ombudsman_repository.dart';
import 'package:flutter/material.dart';

class OmbudsmanController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final messageTextController = TextEditingController();

  final phoneFocus = FocusNode();
  final messageFocus = FocusNode();

  OmbudsmanController() {
    fetchOptions();
  }

  bool? confirmReturns;
  void setConfirmReturns(bool? value) {
    confirmReturns = value;
    notifyListeners();
  }

  OmbudsmanOptionsModel? ombudsmanOptions;
  bool loadingOmbudsman = false;

  OptionModel? currentSubject;
  OptionModel? currentDepartment;

  void setCurrentSubject(OptionModel? value) {
    currentSubject = value;
    notifyListeners();
  }

  void setCurrentDepartment(OptionModel? value) {
    currentDepartment = value;
    notifyListeners();
  }

  fetchOptions() async {
    loadingOmbudsman = true;
    notifyListeners();

    ombudsmanOptions = await OmbudsmanRepository.getOmbudsmanOptions();

    loadingOmbudsman = false;
    notifyListeners();
  }

  bool loadingSendMessage = false;
  Future<void> sendMessage(String registration) async {
    if (loadingSendMessage) return;
    if (!formKey.currentState!.validate()) return;

    loadingSendMessage = true;

    final success = await OmbudsmanRepository.sendMessage(
      registration: registration,
      type: '${currentSubject!.value}',
      message: messageTextController.text,
      phone: phoneTextController.text,
      name: nameTextController.text,
      department: '${currentDepartment!.value}',
      confirmReturns: confirmReturns ?? false,
    );
    final context = App.navigatorKey.currentContext!;
    if (context.mounted) {
      if (success) {
        successSnackBar("Mensagem enviada para a ouvidoria");
      } else {
        errorSnackBar("Mensagem não enviada");
      }
    }
    if (success) clearFields();

    loadingSendMessage = false;
    notifyListeners();
  }

  void clearFields() {
    setCurrentSubject(null);
    setCurrentDepartment(null);
    setConfirmReturns(false);
    nameTextController.clear();
    phoneTextController.clear();
    messageTextController.clear();
  }
}
