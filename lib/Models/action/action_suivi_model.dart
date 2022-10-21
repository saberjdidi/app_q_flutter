class ActionSuiviModel {
  String? nSousAct;
  int? pourcentReal;
  String? causeModif;
  String? dateSuivi;
  String? dateReal;
  int? nAct;
  String? sousAct;
  String? delaiSuivi;
  String? nomprerr;
  int? pourcentSuivie;
  String? rapportEff;
  int? depense;
  int? isd;
  int? expr1;
  String? designation;
  String? commentaire;
  String? dateSaisieSuiv;
  int? ind;
  String? priorite;
  String? gravite;
  String? act;

  ActionSuiviModel(
      {this.nSousAct,
        this.pourcentReal,
        this.causeModif,
        this.dateSuivi,
        this.dateReal,
        this.nAct,
        this.sousAct,
        this.delaiSuivi,
        this.nomprerr,
        this.pourcentSuivie,
        this.rapportEff,
        this.depense,
        this.isd,
        this.expr1,
        this.designation,
        this.commentaire,
        this.dateSaisieSuiv,
        this.ind,
        this.priorite,
        this.gravite,
        this.act});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'nAct' : nAct,
      'nSousAct' : nSousAct,
      'act' : act,
      'sousAct' : sousAct,
      'nomPrenom' : nomprerr,
      'rapportEff' : rapportEff,
      'delaiSuivi' : delaiSuivi,
      'dateReal' : dateReal,
      'dateSuivi' : dateSuivi,
      'causeModif' : causeModif,
      'pourcentReal' : pourcentReal,
      'depense' : depense,
      'commentaire' : commentaire,
      'dateSaisieSuiv' : dateSaisieSuiv,
      'pourcentSuivie' : pourcentSuivie,
      'priorite' : priorite,
      'gravite' : gravite
    };
    return map;
  }
}