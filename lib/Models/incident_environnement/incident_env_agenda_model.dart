class IncidentEnvAgendaModel {
  int? nIncident;
  String? incident;
  String? dateDetect;
  int? idSite;
  int? idProcessus;

  IncidentEnvAgendaModel({
    this.nIncident,
    this.incident,
    this.dateDetect,
    this.idSite,
    this.idProcessus
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'nIncident' : nIncident,
      'incident' : incident,
      'dateDetect' : dateDetect
    };
    return map;
  }

  bool isEqual(IncidentEnvAgendaModel? model) {
    return this.nIncident == model?.nIncident;
  }
}