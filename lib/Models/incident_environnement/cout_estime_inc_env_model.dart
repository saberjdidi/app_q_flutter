class CoutEstimeIncidentEnvModel {
  int? idCout;
  String? cout;

  CoutEstimeIncidentEnvModel({this.idCout, this.cout});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'idCout' : idCout,
      'cout' : cout
    };
    return map;
  }

  bool isEqual(CoutEstimeIncidentEnvModel? model) {
    return this.idCout == model?.idCout;
  }
}