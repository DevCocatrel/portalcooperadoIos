import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  bool showModal = true;

  void markAsSeenModalUpdate() {
    showModal = false;
    notifyListeners();
  }
}
