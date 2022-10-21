class TypeIncidentModel {
  int? idType;
  String? typeIncident;

  TypeIncidentModel({
    this.idType,
    this.typeIncident
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'idType' : idType,
      'typeIncident' : typeIncident
    };
    return map;
  }

  bool isEqual(TypeIncidentModel? model) {
    return this.idType == model?.idType;
  }
}