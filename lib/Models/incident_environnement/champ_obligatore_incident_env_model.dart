class ChampObligatoireIncidentEnvModel {
  int? aspectRappclot;
  int? incCat;
  int? incTypecons;
  int? incTypecause;
  int? aspect;
  int? facteur;
  int? lieu;
  int? condition;
  int? codeImpact;
  int? impact;
  int? codeLieu;
  int? desIncident;
  int? typeIncident;
  int? dateIncident;
  int? actionImmediates;
  int? descIncident;
  int? descCauses;
  int? gravite;

  ChampObligatoireIncidentEnvModel(
      {this.aspectRappclot,
        this.incCat,
        this.incTypecons,
        this.incTypecause,
        this.aspect,
        this.facteur,
        this.lieu,
        this.condition,
        this.codeImpact,
        this.impact,
        this.codeLieu,
        this.desIncident,
        this.typeIncident,
        this.dateIncident,
        this.actionImmediates,
        this.descIncident,
        this.descCauses,
        this.gravite});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'incCat' : incCat,
      'incTypecons' : incTypecons,
      'incTypecause' : incTypecause,
      'lieu' : lieu,
      'desIncident' : desIncident,
      'typeIncident' : typeIncident,
      'dateIncident' : dateIncident,
      'actionImmediates' : actionImmediates,
      'descIncident' : descIncident,
      'descCauses' : descCauses,
      'gravite' : gravite
    };
    return map;
  }
}