class ZoneModel {
  int? idZone;
  int? idUnite;
  String? code;
  String? zone;

  ZoneModel({this.idZone, this.idUnite, this.code, this.zone});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'idZone' : idZone,
      'idUnite' : idUnite,
      'code' : code,
      'zone' : zone
    };
    return map;
  }

  bool isEqual(ZoneModel? model) {
    return this.idZone == model?.idZone;
  }
}