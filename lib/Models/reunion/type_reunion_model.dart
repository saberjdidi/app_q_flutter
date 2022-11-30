class TypeReunionModel {
  int? codeTypeR;
  String? typeReunion;
  String? mat;

  TypeReunionModel({this.codeTypeR, this.typeReunion, this.mat});

  Map<String, dynamic> dataMap() {
    var map = <String, dynamic>{
      'codeTypeR': codeTypeR,
      'typeReunion': typeReunion
    };
    return map;
  }

  Map<String, dynamic> dataMapTypeRMat() {
    var map = <String, dynamic>{
      'codeTypeR': codeTypeR,
      'typeReunion': typeReunion,
      'mat': mat
    };
    return map;
  }

  bool isEqual(TypeReunionModel? model) {
    return this.codeTypeR == model?.codeTypeR;
  }
}
