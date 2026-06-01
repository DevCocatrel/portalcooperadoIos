import 'package:intl/intl.dart';

class UserModel {
  String? token;
  String? refreshToken;
  String? registration;
  String? name;
  String? cpfCnpj;
  String? birthday;
  bool? isAdmin;

  UserModel({
    this.token,
    this.refreshToken,
    this.registration,
    this.name,
    this.cpfCnpj,
    this.birthday,
    this.isAdmin = false,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['Token'];
    refreshToken = json['RefreshToken'];
    registration = json['Matricula'];
    name = ((json['NomeCooperado'] ?? '') as String).trim();
    cpfCnpj = json['CpfCnpj'];
    isAdmin = json['isAdmin'];
    birthday = json['DataNascimento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Matricula'] = registration;
    data['NomeCooperado'] = name;
    data['CpfCnpj'] = cpfCnpj;
    data['DataNascimento'] = birthday;
    data['Token'] = token;
    data['RefreshToken'] = refreshToken;
    data['isAdmin'] = isAdmin;
    return data;
  }

  DateTime? get birthdayDateTime {
    if (birthday != null && birthday!.isNotEmpty) {
      DateFormat format = DateFormat("dd/MM/yyyy HH:mm:ss");
      DateTime? date = format.tryParse(birthday!);
      return date;
    }
    return null;
  }

  String get showBirthday {
    final date = birthdayDateTime;
    if (date == null) return '';
    return DateFormat("dd/MM/yyyy").format(date);
  }

  String? get formattedName {
    if (name == null || name!.isEmpty) {
      return null;
    }
    List<String> prepositions = ['da', 'de', 'do', 'das', 'dos'];

    List<String> parts = name!.split(' ');

    List<String> formattedName = parts.map((part) {
      if (part.length > 1) {
        if (prepositions.contains(part.toLowerCase())) {
          return part.toLowerCase();
        } else {
          return part[0].toUpperCase() + part.substring(1).toLowerCase();
        }
      }
      return part;
    }).toList();

    return formattedName.join(' ');
  }
}
