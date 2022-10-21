class TypeReunionModel {
  int? codeTypeR;
  String? typeReunion;

  TypeReunionModel({this.codeTypeR, this.typeReunion});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeTypeR' : codeTypeR,
      'typeReunion' : typeReunion
    };
    return map;
  }

  bool isEqual(TypeReunionModel? model) {
    return this.codeTypeR == model?.codeTypeR;
  }
}