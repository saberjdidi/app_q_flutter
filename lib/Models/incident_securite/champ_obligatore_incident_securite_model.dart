class ChampObligatoireIncidentSecuriteModel {
  int? incidentGrav;
  int? incidentCat;
  int? incidentTypeCons;
  int? incidentTypeCause;
  int? incidentPostet;
  int? incidentSecteur;
  int? incidentDescInc;
  int? incidentDescCons;
  int? incidentDescCause;
  int? incidentAct;
  int? incidentNbrj;
  int? incidentDesig;
  int? incidentClot;
  int? risqueClot;
  int? incidentSemaine;
  int? incidentSiteLesion;
  int? incidentCauseTypique;
  int? incidentEventDeclencheur;
  int? dateVisite;
  int? comportementsObserve;
  int? comportementRisquesObserves;
  int? correctionsImmediates;

  ChampObligatoireIncidentSecuriteModel(
      {this.incidentGrav,
        this.incidentCat,
        this.incidentTypeCons,
        this.incidentTypeCause,
        this.incidentPostet,
        this.incidentSecteur,
        this.incidentDescInc,
        this.incidentDescCons,
        this.incidentDescCause,
        this.incidentAct,
        this.incidentNbrj,
        this.incidentDesig,
        this.incidentClot,
        this.risqueClot,
        this.incidentSemaine,
        this.incidentSiteLesion,
        this.incidentCauseTypique,
        this.incidentEventDeclencheur,
        this.dateVisite,
        this.comportementsObserve,
        this.comportementRisquesObserves,
        this.correctionsImmediates});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'incidentGrav' : incidentGrav,
      'incidentCat' : incidentCat,
      'incidentTypeCons' : incidentTypeCons,
      'incidentTypeCause' : incidentTypeCause,
      'incidentPostet' : incidentPostet,
      'incidentSecteur' : incidentSecteur,
      'incidentDescInc' : incidentDescInc,
      'incidentDescCons' : incidentDescCons,
      'incidentDescCause' : incidentDescCause,
      'incidentAct' : incidentAct,
      'incidentNbrj' : incidentNbrj,
      'incidentDesig' : incidentDesig,
      'incidentClot' : incidentClot,
      'risqueClot' : risqueClot,
      'incidentSemaine' : incidentSemaine,
      'incidentSiteLesion' : incidentSiteLesion,
      'incidentCauseTypique' : incidentCauseTypique,
      'incidentEventDeclencheur' : incidentEventDeclencheur,
      'dateVisite' : dateVisite,
      'comportementsObserve' : comportementsObserve,
      'comportementRisquesObserves' : comportementRisquesObserves,
      'correctionsImmediates' : correctionsImmediates
    };
    return map;
  }
}