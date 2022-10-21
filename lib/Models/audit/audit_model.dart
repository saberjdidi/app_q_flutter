import 'dart:typed_data';

class AuditModel {
  int? online;
  String? refAudit;
  int? idAudit;
  String? dateDebPrev;
  int? etat;
  String? dateDeb;
  String? champ;
  String? site;
  String? interne;
  String? cloture;
  String? typeA;
  String? audit;
  int? codeChamp;
  String? dateFinPrev;
  String? dateFin;
  String? constat;
  String? objectif;
  int? codeTypeA;
  int? codeSite;
  int? validation;
  String? declencheur;
  int? idProcess;
  int? idDomaine;
  int? idDirection;
  int? idService;
  int? cloturee;
  String? dateclot;
  String? dateSaisieClot;
  String? rapportClot;
  String? respclot;
  Uint8List? listCodeChamp;

  AuditModel({
        this.online,
        this.refAudit,
        this.audit,
        this.codeChamp,
        this.dateDebPrev,
        this.dateFinPrev,
        this.etat,
        this.dateDeb,
        this.dateFin,
        this.constat,
        this.objectif,
        this.codeTypeA,
        this.typeA,
        this.codeSite,
        this.validation,
        this.interne,
        this.declencheur,
        this.idProcess,
        this.idDomaine,
        this.idDirection,
        this.idService,
        this.cloturee,
        this.dateclot,
        this.dateSaisieClot,
        this.rapportClot,
        this.respclot,
        this.listCodeChamp
      });

  AuditModel.fromJson(Map<String, dynamic> json) {
    online = 1;
    idAudit = json['idAudit'];
    refAudit = json['refAudit'];
    dateDebPrev = json['dateDebPrev'];
    etat = json['etat'];
    dateDeb = json['dateDeb'];
    champ = json['champ'];
    site = json['site'];
    interne = json['interne'];
    cloture = json['cloture'];
    typeA = json['typeA'];
    codeTypeA = json['codeTypeA'];
    validation = json['validation'];
    dateFinPrev = json['dateFinPrev'];
    audit = json['audit'];
    objectif = json['objectif'];
    rapportClot = json['rapportClot'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refAudit'] = this.refAudit;
    data['dateDebPrev'] = this.dateDebPrev;
    data['etat'] = this.etat;
    data['dateDeb'] = this.dateDeb;
    data['champ'] = this.champ;
    data['site'] = this.site;
    data['idAudit'] = this.idAudit;
    data['interne'] = this.interne;
    data['cloture'] = this.cloture;
    data['typeA'] = this.typeA;
    return data;
  }

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'idAudit' : idAudit,
      'refAudit' : refAudit,
      'dateDebPrev' : dateDebPrev,
      'etat' : etat,
      'dateDeb' : dateDeb,
      'champ' : champ,
      'site' : site,
      'interne' : interne,
      'cloture' : cloture,
      'typeA' : typeA,
      'codeTypeA' : codeTypeA,
      'validation' : validation,
      'dateFinPrev' : dateFinPrev,
      'audit' : audit,
      'objectif' : objectif,
      'rapportClot' : rapportClot,
    };
    return map;
  }
  Map<String, dynamic> dataMapSync(){
    var map = <String, dynamic>{
      'online' : online,
      'idAudit' : idAudit,
      'refAudit' : refAudit,
      'dateDebPrev' : dateDebPrev,
      'dateFinPrev' : dateFinPrev,
      'etat' : etat,
      'validation' : validation,
      'dateDeb' : dateDeb,
      'champ' : champ,
      'site' : site,
      'interne' : interne,
      'cloture' : cloture,
      'typeA' : typeA,
      'codeTypeA' : codeTypeA,
      'audit' : audit,
      'objectif' : objectif,
      'rapportClot' : rapportClot,
      'codeSite' : codeSite,
      'idProcess' : idProcess,
      'idDomaine' : idDomaine,
      'idDirection' : idDirection,
      'idService' : idService,
      'listCodeChamp' : listCodeChamp,
    };
    return map;
  }

  AuditModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    idAudit = json['idAudit'];
    refAudit = json['refAudit'];
    dateDebPrev = json['dateDebPrev'];
    dateFinPrev = json['dateFinPrev'];
    etat = json['etat'];
    validation = json['validation'];
    dateDeb = json['dateDeb'];
    champ = json['champ'];
    site = json['site'];
    interne = json['interne'];
    cloture = json['cloture'];
    typeA = json['typeA'];
    codeTypeA = json['codeTypeA'];
    audit = json['audit'];
    objectif = json['objectif'];
    rapportClot = json['rapportClot'];
    codeSite = json['codeSite'];
    idProcess = json['idProcess'];
    idDomaine = json['idDomaine'];
    idDirection = json['idDirection'];
    idService = json['idService'];
    listCodeChamp = json['listCodeChamp'];

  }

  Map<String, dynamic> dataMapAuditAudite(){
    var map = <String, dynamic>{
      'idAudit' : idAudit,
      'refAudit' : refAudit,
      'dateDebPrev' : dateDebPrev,
      'champ' : champ,
      'interne' : interne,
    };
    return map;
  }
  Map<String, dynamic> dataMapAuditAuditeur(){
    var map = <String, dynamic>{
      'idAudit' : idAudit,
      'refAudit' : refAudit,
      'dateDebPrev' : dateDebPrev,
      'champ' : champ,
      'interne' : interne,
    };
    return map;
  }
  Map<String, dynamic> dataMapRapportAudit(){
    var map = <String, dynamic>{
      'idAudit' : idAudit,
      'refAudit' : refAudit,
      'champ' : champ,
      'interne' : interne,
      'typeA' : typeA,
    };
    return map;
  }
}