class SousActionModel {
  int? nSousAct;
  int? cloture;
  int? nAct;
  String? sousAct;
  String? delaiReal;
  String? delaiSuivi;
  String? dateReal;
  String? dateSuivi;
  int? coutPrev;
  int? pourcentReal;
  int? depense;
  int? pourcentSuivie;
  String? rapportEff;
  String? commentaire;
  String? respRealNom;
  String? respReal;
  String? respSuivi;
  String? respSuivieNom;
  //String? designation;
  String? priorite;
  int? codePriorite;
  String? gravite;
  int? codeGravite;
  String? processus;
  String? risques;
  int? online;

  SousActionModel(
      {this.nSousAct,
        this.cloture,
        this.nAct,
        this.sousAct,
        this.delaiReal,
        this.delaiSuivi,
        this.dateReal,
        this.dateSuivi,
        this.coutPrev,
        this.pourcentReal,
        this.depense,
        this.pourcentSuivie,
        this.rapportEff,
        this.commentaire,
        this.respRealNom,
        this.respReal,
        this.respSuivi,
        this.respSuivieNom,
        //this.designation,
        this.priorite,
        this.gravite,
        this.processus,
        this.risques,
        this.online});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'nSousAct' : nSousAct,
      'nAct' : nAct,
      'cloture' : cloture,
      'sousAct' : sousAct,
      'delaiReal' : delaiReal,
      'delaiSuivi' : delaiSuivi,
      'dateReal' : dateReal,
      'dateSuivi': dateSuivi,
      'coutPrev' : coutPrev,
      'pourcentReal' : pourcentReal,
      'pourcentSuivie' : pourcentSuivie,
      'depense' : depense,
      'rapportEff' : rapportEff,
      'commentaire' : commentaire,
      'respRealNompre' : respRealNom,
      'respSuiviNompre' : respSuivieNom,
      'respRealMat' : respReal,
      'respSuiviMat' : respSuivi,
      //'designation' : designation,
      'priorite' : priorite,
      'codePriorite': codePriorite,
      'gravite' : gravite,
      'codeGravite' : codeGravite,
      'processus' : processus,
      'risques' : risques,
      'online' : online
    };
    return map;
  }

  SousActionModel.fromDBLocal(Map<String, dynamic> json) {
    nSousAct = json['nSousAct'];
    nAct = json['nAct'];
    cloture = json['cloture'];
    sousAct = json['sousAct'];
    delaiReal = json['delaiReal'];
    delaiSuivi = json['delaiSuivi'];
    dateReal = json['dateReal'];
    dateSuivi = json['dateSuivi'];
    coutPrev = json['coutPrev'];
    pourcentReal = json['pourcentReal'];
    pourcentSuivie = json['pourcentSuivie'];
    depense = json['depense'];
    rapportEff = json['rapportEff'];
    commentaire = json['commentaire'];
    respRealNom = json['respRealNompre'];
    respSuivieNom = json['respSuiviNompre'];
    respReal = json['respRealMat'];
    respSuivi = json['respSuiviMat'];
    priorite = json['priorite'];
    codePriorite = json['codePriorite'];
    gravite = json['gravite'];
    codeGravite = json['codeGravite'];
    processus = json['processus'];
    risques = json['risques'];
    online = json['online'];

  }
}