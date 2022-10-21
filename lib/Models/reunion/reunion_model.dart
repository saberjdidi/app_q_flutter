class ReunionModel {
  int? online;
  int? nReunion;
  String? typeReunion;
  int? codeTypeReunion;
  String? datePrev;
  String? dateReal;
  String? etat;
  String? lieu;
  String? site;
  String? ordreJour;
  String? strEtat;
  String? reunionPlus0;
  String? reunionPlus1;
  String? dureePrev;
  String? heureDeb;
  String? heureFin;
  String? dureReal;
  String? commentaire;
  int? codeSite;
  int? codeProcessus;
  int? codeDirection;
  int? codeService;
  int? codeActivity;

  ReunionModel(
      {
        this.online,
        this.nReunion,
        this.typeReunion,
        this.codeTypeReunion,
        this.datePrev,
        this.dateReal,
        this.etat,
        this.lieu,
        this.site,
        this.ordreJour,
        this.strEtat,
        this.reunionPlus0,
        this.reunionPlus1,
        this.dureePrev,
        this.heureDeb,
        this.heureFin,
        this.dureReal,
        this.commentaire,
        this.codeSite,
        this.codeProcessus,
        this.codeDirection,
        this.codeService,
        this.codeActivity});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'nReunion' : nReunion,
      'typeReunion': typeReunion,
      'codeTypeReunion' : codeTypeReunion,
      'datePrev' : datePrev,
      'dateReal' : dateReal,
      'etat' : etat,
      'lieu' : lieu,
      'site' : site,
      'ordreJour' : ordreJour,
    };
    return map;
  }

  Map<String, dynamic> dataMapSync(){
    var map = <String, dynamic>{
      'online' : online,
      'nReunion' : nReunion,
      'typeReunion': typeReunion,
      'codeTypeReunion' : codeTypeReunion,
      'datePrev' : datePrev,
      'dateReal' : dateReal,
      'etat' : etat,
      'lieu' : lieu,
      'site' : site,
      'ordreJour' : ordreJour,
      'dureePrev' : dureePrev,
      'heureDeb' : heureDeb,
      'heureFin' : heureFin,
      'dureeReal' : dureReal,
      'commentaire' : commentaire,
      'codeSite' : codeSite,
      'codeProcessus' : codeProcessus,
      'codeDirection' : codeDirection,
      'codeService' : codeService,
      'codeActivity' : codeActivity,
    };
    return map;
  }

  ReunionModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    nReunion = json['nReunion'];
    typeReunion = json['typeReunion'];
    codeTypeReunion = json['codeTypeReunion'];
    datePrev = json['datePrev'];
    dateReal = json['dateReal'];
    etat = json['etat'];
    lieu = json['lieu'];
    site = json['site'];
    ordreJour = json['ordreJour'];
    dureePrev = json['dureePrev'];
    heureDeb = json['heureDeb'];
    heureFin = json['heureFin'];
    dureReal = json['dureeReal'];
    commentaire = json['commentaire'];
    codeSite = json['codeSite'];
    codeProcessus = json['codeProcessus'];
    codeDirection = json['codeDirection'];
    codeService = json['codeService'];
    codeActivity = json['codeActivity'];

  }

  Map<String, dynamic> dataMapReunionInformer(){
    var map = <String, dynamic>{
      'nReunion' : nReunion,
      'typeReunion': typeReunion,
      'datePrev' : datePrev,
      'heureDeb' : heureDeb,
      'lieu' : lieu
    };
    return map;
  }

  Map<String, dynamic> dataMapReunionPlanifier(){
    var map = <String, dynamic>{
      'nReunion' : nReunion,
      'typeReunion': typeReunion,
      'datePrev' : datePrev,
      'ordreJour' : ordreJour,
      'heureDeb' : heureDeb,
      'heureFin' : heureFin,
      'lieu' : lieu
    };
    return map;
  }

}