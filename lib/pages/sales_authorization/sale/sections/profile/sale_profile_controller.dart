import 'package:flutter/material.dart';

class SaleProfileController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final applicantNameController = TextEditingController();
  final applicantNameControllerNode = FocusNode();
}
