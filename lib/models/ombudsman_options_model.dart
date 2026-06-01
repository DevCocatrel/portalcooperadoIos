import 'package:cocatrel/models/option_model.dart';

class OmbudsmanOptionsModel {
  List<OptionModel>? subjects;
  List<OptionModel>? departments;

  OmbudsmanOptionsModel({
    this.departments,
    this.subjects,
  });

  OmbudsmanOptionsModel.fromJson(Map<String, dynamic> json) {
    if (json['Assuntos'] != null && json['Assuntos'] is List) {
      final list = (json['Assuntos'] as List)
          .map((data) => OptionModel.fromJson(data))
          .toList();
      subjects = list;
    }

    if (json['Departamentos'] != null && json['Departamentos'] is List) {
      final list = (json['Departamentos'] as List)
          .map((data) => OptionModel.fromJson(data))
          .toList();
      departments = list;
    }
  }
}
