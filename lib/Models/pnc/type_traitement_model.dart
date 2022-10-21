class TypeTraitementModel {
  int? codeTypeT;
  String? typeT;
  String? valid;

  TypeTraitementModel({this.codeTypeT, this.typeT, this.valid});

  TypeTraitementModel.fromJson(Map<String, dynamic> json) {
    codeTypeT = json['codeTypeT'];
    typeT = json['typeT'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codeTypeT'] = this.codeTypeT;
    data['typeT'] = this.typeT;
    data['valid'] = this.valid;
    return data;
  }

  bool isEqual(TypeTraitementModel? model) {
    return this.codeTypeT == model?.codeTypeT;
  }
}