import 'dart:typed_data';

class IncidentEnvModel {
  int? online;
  int? n;
  String? incident;
  String? dateDetect;
  String? lieu;
  String? type;
  String? source;
  int? act;
  String? secteur;
  String? poste;
  String? site;
  String? processus;
  String? domaine;
  String? direction;
  String? service;
  String? typeCause;
  String? typeConseq;
  String? delaiTrait;
  int? traite;
  int? cloture;
  String? categorie;
  String? gravite;
  int? statut;
  String? codeLieu;
  String? codeSecteur;
  int? codeType;
  int? codeGravite;
  int? codeSource;
  int? codeCoutEsteme;
  String? detectedEmployeMatricule;
  String? origineEmployeMatricule;
  String? rapport;
  int? codeCategory;
  String? heure;
  int? codeSite;
  int? codeProcessus;
  int? codeDirection;
  int? codeService;
  int? codeActivity;
  String? descriptionConsequence;
  String? descriptionCause;
  String? actionImmediate;
  String? quantity;
  String? numInterne;
  String? isps;
  Uint8List? listTypeCause;
  Uint8List? listTypeConsequence;

  IncidentEnvModel(
      {
        this.online,
        this.n,
        this.incident,
        this.dateDetect,
        this.lieu,
        this.type,
        this.source,
        this.act,
        this.secteur,
        this.poste,
        this.site,
        this.processus,
        this.domaine,
        this.direction,
        this.service,
        this.typeCause,
        this.typeConseq,
        this.delaiTrait,
        this.traite,
        this.cloture,
        this.categorie,
        this.gravite,
        this.statut,
        this.codeLieu,
        this.codeSecteur,
        this.codeType,
        this.codeGravite,
        this.codeSource,
        this.codeCoutEsteme,
        this.detectedEmployeMatricule,
        this.origineEmployeMatricule,
        this.rapport,
        this.codeCategory,
        this.heure,
        this.codeSite,
        this.codeProcessus,
        this.codeDirection,
        this.codeService,
        this.codeActivity,
        this.descriptionConsequence,
        this.descriptionCause,
        this.actionImmediate,
        this.quantity,
        this.numInterne,
        this.isps,
        this.listTypeCause,
        this.listTypeConsequence
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'n' : n,
      'incident' : incident,
      'dateDetect' : dateDetect,
      'lieu' : lieu,
      'type' : type,
      'source' : source,
      'act' : act,
      'secteur' : secteur,
      'poste' : poste,
      'site' : site,
      'processus' : processus,
      'domaine' : domaine,
      'direction' : direction,
      'service' : service,
      'typeCause' : typeCause,
      'typeConseq' : typeConseq,
      'delaiTrait' : delaiTrait,
      'traite' : traite,
      'cloture' : cloture,
      'categorie' : categorie,
      'gravite' : gravite,
      'statut' : statut,

    };
    return map;
  }

  Map<String, dynamic> dataMapSync(){
    var map = <String, dynamic>{
      'online' : online,
      'n' : n,
      'incident' : incident,
      'dateDetect' : dateDetect,
      'lieu' : lieu,
      'type' : type,
      'source' : source,
      'act' : act,
      'secteur' : secteur,
      'poste' : poste,
      'site' : site,
      'processus' : processus,
      'domaine' : domaine,
      'direction' : direction,
      'service' : service,
      'typeCause' : typeCause,
      'typeConseq' : typeConseq,
      'delaiTrait' : delaiTrait,
      'traite' : traite,
      'cloture' : cloture,
      'categorie' : categorie,
      'gravite' : gravite,
      'statut' : statut,
      'codeLieu' : codeLieu,
      'codeSecteur' : codeSecteur,
      'codeType' : codeType,
      'codeGravite' : codeGravite,
      'codeSource' : codeSource,
      'codeCoutEsteme' : codeCoutEsteme,
      'detectedEmployeMatricule' : detectedEmployeMatricule,
      'origineEmployeMatricule' : origineEmployeMatricule,
      'rapport' : rapport,
      'codeCategory': codeCategory,
      'heure' : heure,
      'codeSite' : codeSite,
      'codeProcessus' : codeProcessus,
      'codeDirection' : codeDirection,
      'codeService' : codeService,
      'codeActivity' : codeActivity,
      'descriptionConsequence' : descriptionConsequence,
      'descriptionCause' : descriptionCause,
      'actionImmediate' : actionImmediate,
      'quantity' : quantity,
      'numInterne' : numInterne,
      'isps' : isps,
      'listTypeCause' : listTypeCause,
      'listTypeConsequence' : listTypeConsequence
    };
    return map;
  }

  IncidentEnvModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    n = json['n'];
    incident = json['incident'];
    dateDetect = json['dateDetect'];
    codeLieu = json['codeLieu'];
    codeType = json['codeType'];
    codeGravite = json['codeGravite'];
    codeSource = json['codeSource'];
    detectedEmployeMatricule = json['detectedEmployeMatricule'];
    origineEmployeMatricule = json['origineEmployeMatricule'];
    delaiTrait = json['delaiTrait'];
    rapport = json['rapport'];
    codeCategory = json['codeCategory'];
    heure = json['heure'];
    codeSecteur = json['codeSecteur'];
    descriptionConsequence = json['descriptionConsequence'];
    descriptionCause = json['descriptionCause'];
    actionImmediate = json['actionImmediate'];
    quantity = json['quantity'];
    numInterne = json['numInterne'];
    codeSite = json['codeSite'];
    codeProcessus = json['codeProcessus'];
    codeActivity = json['codeActivity'];
    codeDirection = json['codeDirection'];
    codeService = json['codeService'];
    isps = json['isps'];
    codeCoutEsteme = json['codeCoutEsteme'];
    delaiTrait = json['delaiTrait'];
    listTypeConsequence = json['listTypeConsequence'];
    listTypeCause = json['listTypeCause'];
  }
}