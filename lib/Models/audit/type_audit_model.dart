class TypeAuditModel {
  int? codeType;
  String? type;

  TypeAuditModel({
    this.codeType,
    this.type
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeType' : codeType,
      'type' : type
    };
    return map;
  }

  bool isEqual(TypeAuditModel? model) {
    return this.codeType == model?.codeType;
  }
}