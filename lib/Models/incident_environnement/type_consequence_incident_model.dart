class TypeConsequenceIncidentModel {
  int? online;
  int? idIncidentConseq;
  int? idIncident;
  int? idConsequence;
  String? typeConsequence;

  TypeConsequenceIncidentModel(
      {this.online,
        this.idIncidentConseq,
        this.idIncident,
        this.idConsequence,
        this.typeConsequence});

  Map<String, dynamic> dataMapIncidentEnv(){
    var map = <String, dynamic>{
      'idTypeConseq' : idConsequence,
      'typeConseq' : typeConsequence
    };
    return map;
  }

  Map<String, dynamic> dataMapIncidentEnvRattacher(){
    var map = <String, dynamic>{
      'online' : online,
      'incident' : idIncident,
      'idIncidentConseq' : idIncidentConseq,
      'idTypeConseq' : idConsequence,
      'typeConseq' : typeConsequence
    };
    return map;
  }

  Map<String, dynamic> dataMapIncSecRattacher(){
    var map = <String, dynamic>{
      'online' : online,
      'incident' : idIncident,
      'idIncidentConseq' : idIncidentConseq,
      'idTypeConseq' : idConsequence,
      'typeConseq' : typeConsequence
    };
    return map;
  }

  TypeConsequenceIncidentModel.fromDBLocalIncEnv(Map<String, dynamic> json) {
    online = json['online'];
    idIncident = json['incident'];
    idIncidentConseq = json['idIncidentConseq'];
    idConsequence = json['idTypeConseq'];
    typeConsequence = json['typeConseq'];

  }

  TypeConsequenceIncidentModel.fromDBLocalIncSec(Map<String, dynamic> json) {
    online = json['online'];
    idIncident = json['incident'];
    idIncidentConseq = json['idIncidentConseq'];
    idConsequence = json['idTypeConseq'];
    typeConsequence = json['typeConseq'];

  }

  bool isEqual(TypeConsequenceIncidentModel? model) {
    return this.idIncidentConseq == model?.idIncidentConseq;
  }
}