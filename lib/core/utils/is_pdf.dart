import 'dart:convert';
import 'dart:typed_data';

bool isPdf(Uint8List data) {
  try {
    if (data.length < 4) {
      return false;
    }

    String header = utf8.decode(data.sublist(0, 4));
    return header == '%PDF';
  } catch (_) {
    return false;
  }
}
