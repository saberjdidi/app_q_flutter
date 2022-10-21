class UniteModel {
  int? idUnite;
  String? code;
  String? unite;

  UniteModel({this.idUnite, this.code, this.unite});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'idUnite' : idUnite,
      'code' : code,
      'unite' : unite
    };
    return map;
  }

  bool isEqual(UniteModel? model) {
    return this.idUnite == model?.idUnite;
  }
}