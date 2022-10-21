class GraviteModel {
  int? codegravite;
  String? gravite;

  GraviteModel({this.codegravite, this.gravite});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codegravite' : codegravite,
      'gravite' : gravite
    };
    return map;
  }

  bool isEqual(GraviteModel? model) {
    return this.codegravite == model?.codegravite;
  }
}