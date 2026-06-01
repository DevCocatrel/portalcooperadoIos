import 'package:flutter/material.dart';

class BasicDropdownNotifier extends ChangeNotifier {
  final OverlayPortalController _basicDropdownController =
      OverlayPortalController();

  OverlayPortalController get basicDropdownController =>
      _basicDropdownController;

  void toggle() {
    _basicDropdownController.toggle();
    notifyListeners();
  }

  void close() {
    if (_basicDropdownController.isShowing) {
      _basicDropdownController.hide();
      notifyListeners();
    }
  }
}
