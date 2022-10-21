import 'dart:typed_data';

class IncidentSecuriteModel {
  int? ref;
  int? online;
  String? typeIncident;
  String? site;
  String? dateInc;
  String? contract;
  int? statut;
  String? designation;
  String? gravite;
  String? categorie;
  String? typeConsequence;
  String? typeCause;
  String? secteur;
  String? dateCreation;
  String? detectedEmployeMatricule;
  String? codeType;
  String? codePoste;
  String? codeGravite;
  String? codeCategory;
  String? codeSecteur;
  String? codeEvenementDeclencheur;
  String? heure;
  int? codeCoutEsteme;
  int? codeSite;
  int? codeProcessus;
  int? codeDirection;
  int? codeService;
  int? codeActivity;
  String? descriptionIncident;
  String? descriptionConsequence;
  String? descriptionCause;
  String? actionImmediate;
  int? nombreJour;
  String? numInterne;
  String? isps;
  String? week;
  Uint8List? listTypeCause;
  Uint8List? listTypeConsequence;
  Uint8List? listCauseTypique;
  Uint8List? listSiteLesion;

  IncidentSecuriteModel(
      {
        this.ref,
        this.online,
        this.typeIncident,
        this.site,
        this.dateInc,
        this.contract,
        this.statut,
        this.designation,
        this.gravite,
        this.categorie,
        this.typeConsequence,
        this.typeCause,
        this.secteur,
        this.dateCreation,
        this.detectedEmployeMatricule,
        this.codeType,
        this.codePoste,
        this.codeGravite,
        this.codeCategory,
        this.codeSecteur,
        this.codeEvenementDeclencheur,
        this.heure,
        this.codeCoutEsteme,
        this.codeSite,
        this.codeProcessus,
        this.codeDirection,
        this.codeService,
        this.codeActivity,
        this.descriptionIncident,
        this.descriptionConsequence,
        this.descriptionCause,
        this.actionImmediate,
        this.nombreJour,
        this.numInterne,
        this.isps,
        this.week,
        this.listTypeCause,
        this.listTypeConsequence,
        this.listCauseTypique,
        this.listSiteLesion
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'ref' : ref,
      'online' : online,
      'typeIncident' : typeIncident,
      'site' : site,
      'dateInc' : dateInc,
      'contract' : contract,
      'statut' : statut,
      'designation' : designation,
      'gravite' : gravite,
      'categorie' : categorie,
      'typeConsequence' : typeConsequence,
      'typeCause' : typeCause,
      'secteur' : secteur,
    };
    return map;
  }

  Map<String, dynamic> dataMapSync(){
    var map = <String, dynamic>{
      'ref' : ref,
      'online' : online,
      'typeIncident' : typeIncident,
      'site' : site,
      'dateInc' : dateInc,
      'contract' : contract,
      'statut' : statut,
      'designation' : designation,
      'gravite' : gravite,
      'categorie' : categorie,
      'typeConsequence' : typeConsequence,
      'typeCause' : typeCause,
      'secteur' : secteur,
      'dateCreation' : dateCreation,
      'detectedEmployeMatricule' : detectedEmployeMatricule,
      'codeType' : codeType,
      'codePoste' : codePoste,
      'codeGravite' : codeGravite,
      'codeCategory': codeCategory,
      'codeSecteur' : codeSecteur,
      'codeEvenementDeclencheur' : codeEvenementDeclencheur,
      'heure' : heure,
      'codeCoutEsteme' : codeCoutEsteme,
      'codeSite' : codeSite,
      'codeProcessus' : codeProcessus,
      'codeDirection' : codeDirection,
      'codeService' : codeService,
      'codeActivity' : codeActivity,
      'descriptionIncident' : descriptionIncident,
      'descriptionConsequence' : descriptionConsequence,
      'descriptionCause' : descriptionCause,
      'actionImmediate' : actionImmediate,
      'nombreJour' : nombreJour,
      'numInterne' : numInterne,
      'isps' : isps,
      'week' : week,
      'listTypeCause' : listTypeCause,
      'listTypeConsequence' : listTypeConsequence,
      'listCauseTypique' : listCauseTypique,
      'listSiteLesion' : listSiteLesion
    };
    return map;
  }

  IncidentSecuriteModel.fromDBLocal(Map<String, dynamic> json){
    online = json['online'];
    ref = json['ref'];
    dateInc = json['dateInc'];
    heure = json['heure'];
    codeType = json['codeType'];
    codePoste = json['codePoste'];
    codeGravite = json['codeGravite'];
    codeCategory = json['codeCategory'];
    descriptionIncident = json['descriptionIncident'];
    descriptionCause = json['descriptionCause'];
    designation = json['designation'];
    descriptionConsequence = json['descriptionConsequence'];
    nombreJour = json['nombreJour'];
    actionImmediate = json['actionImmediate'];
    codeSite = json['codeSite'];
    codeSecteur = json['codeSecteur'];
    codeProcessus = json['codeProcessus'];
    codeActivity = json['codeActivity'];
    codeDirection = json['codeDirection'];
    codeService = json['codeService'];
    detectedEmployeMatricule = json['detectedEmployeMatricule'];
    numInterne = json['numInterne'];
    isps = json['isps'];
    codeCoutEsteme = json['codeCoutEsteme'];
    dateCreation = json['dateCreation'];
    week = json['week'];
    codeEvenementDeclencheur = json['codeEvenementDeclencheur'];
    listTypeCause = json['listTypeCause'];
    listTypeConsequence = json['listTypeConsequence'];
    listCauseTypique = json['listCauseTypique'];
    listSiteLesion = json['listSiteLesion'];
  }


}