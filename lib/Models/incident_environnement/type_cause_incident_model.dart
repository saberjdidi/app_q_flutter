class TypeCauseIncidentModel {
  int? online;
  int? idIncidentCause;
  int? idIncident;
  int? idTypeCause;
  String? typeCause;

  TypeCauseIncidentModel({
        this.online,
        this.idIncidentCause,
        this.idIncident,
        this.idTypeCause,
        this.typeCause
      });

  Map<String, dynamic> dataMapIncidentEnv(){
    var map = <String, dynamic>{
      'idTypeCause' : idTypeCause,
      'typeCause' : typeCause
    };
    return map;
  }

  Map<String, dynamic> dataMapIncidentEnvRattacher(){
    var map = <String, dynamic>{
      'online' : online,
      'incident' : idIncident,
      'idTypeCause' : idTypeCause,
      'idIncidentCause' : idIncidentCause,
      'typeCause' : typeCause
    };
    return map;
  }

  TypeCauseIncidentModel.fromDBLocalIncEnv(Map<String, dynamic> json) {
    online = json['online'];
    idIncident = json['incident'];
    idTypeCause = json['idTypeCause'];
    idIncidentCause = json['idIncidentCause'];
    typeCause = json['typeCause'];
  }

  Map<String, dynamic> dataMapIncidentSecRattacher(){
    var map = <String, dynamic>{
      'online' : online,
      'incident' : idIncident,
      'idTypeCause' : idTypeCause,
      'idIncidentCause' : idIncidentCause,
      'typeCause' : typeCause
    };
    return map;
  }

  TypeCauseIncidentModel.fromDBLocalIncSec(Map<String, dynamic> json) {
    online = json['online'];
    idIncident = json['incident'];
    idTypeCause = json['idTypeCause'];
    idIncidentCause = json['idIncidentCause'];
    typeCause = json['typeCause'];
  }

  bool isEqual(TypeCauseIncidentModel? model) {
    return this.idIncidentCause == model?.idIncidentCause;
  }
}