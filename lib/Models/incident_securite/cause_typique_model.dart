class CauseTypiqueModel {
  int? online;
  int? idIncidentCauseTypique;
  String? causeTypique;
  int? idCauseTypique;
  int? idIncident;

  CauseTypiqueModel({
    this.online,
    this.idIncidentCauseTypique,
    this.causeTypique,
    this.idCauseTypique,
    this.idIncident
  });

  Map<String, dynamic> dataMapIncSecARattacher(){
    var map = <String, dynamic>{
      'idTypeCause' : idIncidentCauseTypique,
      'causeTypique' : causeTypique,
      'idCauseTypique' : idCauseTypique
    };
    return map;
  }

  Map<String, dynamic> dataMapIncSecRattacher(){
    var map = <String, dynamic>{
      'online' : online,
      'incident' : idIncident,
      'idIncidentCauseTypique' : idIncidentCauseTypique,
      'causeTypique' : causeTypique,
      'idCauseTypique' : idCauseTypique
    };
    return map;
  }

  CauseTypiqueModel.fromDBLocal(Map<String, dynamic> json){
    online = json['online'];
    idIncident = json['incident'];
    idIncidentCauseTypique = json['idIncidentCauseTypique'];
    causeTypique = json['causeTypique'];
    idCauseTypique = json['idCauseTypique'];
  }

  bool isEqual(CauseTypiqueModel? model) {
    return this.idIncidentCauseTypique == model?.idIncidentCauseTypique;
  }
}