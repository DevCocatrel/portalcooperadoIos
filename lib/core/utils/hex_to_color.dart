import 'package:flutter/material.dart';

class ColorTransform {
  static bool isHexColor(String hex) {
    if (hex.length != 7) return false;
    if (!hex.startsWith("#")) return false;

    return true;
  }

  static Color hexToColor(String hex, {Color defaultColor = Colors.red}) {
    if (!isHexColor(hex)) return defaultColor;

    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
