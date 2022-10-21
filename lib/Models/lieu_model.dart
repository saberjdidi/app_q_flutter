class LieuModel {
  String? code;
  String? lieu;

  LieuModel({this.code, this.lieu});

  Map<String, dynamic> dataMapIncidentEnv(){
    var map = <String, dynamic>{
      'code' : code,
      'lieu' : lieu
    };
    return map;
  }

  bool isEqual(LieuModel? model) {
    return this.code == model?.code;
  }
}