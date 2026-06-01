import 'package:flutter/material.dart';

class DialogController extends ChangeNotifier {
  bool isAgree = false;
  bool hasError = false;
  bool isLoading = false;

  void toggleAgree() {
    isAgree = !isAgree;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setError(bool value) {
    hasError = value;
    notifyListeners();
  }
}
