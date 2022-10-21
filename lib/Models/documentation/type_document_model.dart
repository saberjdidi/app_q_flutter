class TypeDocumentModel {
  int? codeType;
  String? type;

  TypeDocumentModel({
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

  bool isEqual(TypeDocumentModel? model) {
    return this.codeType == model?.codeType;
  }
}