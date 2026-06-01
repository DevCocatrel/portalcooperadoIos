class OptionModel {
  String? title;
  String? value;

  OptionModel(this.title, this.value);

  OptionModel.fromJson(Map<String, dynamic> json) {
    value = json['Codigo'] != null ? '${json['Codigo']}' : '';
    title = json['Descricao'];
  }
}
