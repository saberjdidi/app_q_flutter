class ActionRealisationModel {
  String? nomPrenom;
  String? causemodif;
  int? nAct;
  int? nSousAct;
  String? respReal;
  String? sousAct;
  String? delaiReal;
  String? delaiSuivi;
  String? dateReal;
  String? dateSuivi;
  int? coutPrev;
  int? pourcentReal;
  int? depense;
  String? rapportEff;
  int? pourcentSuivie;
  String? commentaire;
  int? cloture;
  String? designation;
  String? dateSaisieReal;
  //String? dateSaisieSuivi;
  int? ind;
  String? priorite;
  String? gravite;
  int? returnRespS;
  String? act;

  ActionRealisationModel(
      {this.nomPrenom,
        this.causemodif,
        this.nAct,
        this.nSousAct,
        this.respReal,
        this.sousAct,
        this.delaiReal,
        this.delaiSuivi,
        this.dateReal,
        this.dateSuivi,
        this.coutPrev,
        this.pourcentReal,
        this.depense,
        this.rapportEff,
        this.pourcentSuivie,
        this.commentaire,
        this.cloture,
        this.designation,
        this.dateSaisieReal,
        //this.dateSaisieSuivi,
        this.ind,
        this.priorite,
        this.gravite,
        this.returnRespS,
        this.act});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'nAct' : nAct,
      'nSousAct' : nSousAct,
      'act' : act,
      'sousAct' : sousAct,
      'nomPrenom' : nomPrenom,
      'respReal' : respReal,
      'delaiReal' : delaiReal,
      'delaiSuivi' : delaiSuivi,
      'dateReal' : dateReal,
      'dateSuivi' : dateSuivi,
      'pourcentReal' : pourcentReal,
      'depense' : depense,
      'commentaire' : commentaire,
      'dateSaisieReal' : dateSaisieReal,
      'cloture' : cloture,
      'priorite' : priorite,
      'gravite' : gravite
    };
    return map;
  }
}