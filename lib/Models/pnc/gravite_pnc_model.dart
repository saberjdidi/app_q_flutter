class GravitePNCModel {
  int? nGravite;
  String? gravite;

  GravitePNCModel({this.nGravite, this.gravite});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'nGravite' : nGravite,
      'gravite' : gravite
    };
    return map;
  }

  bool isEqual(GravitePNCModel? model) {
    return this.nGravite == model?.nGravite;
  }
}