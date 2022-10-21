import 'dart:typed_data';

import '../../Utils/shared_preference.dart';

class ActionSync {
  String? action;
  int? typea;
  int? codesource;
  String? refAudit;
  String? descpb;
  String? cause;
  String? datepa;
  int? cloture;
  int? codesite;
  String? matdeclencheur;
  String? commentaire;
  String? respsuivi;
  String? datesaisie;
  String? matOrigine;
  String? objectif;
  String? respclot;
  int? annee;
  String? refInterne;
  int? direction;
  int? process;
  int? domaine;
  int? service;
  //String? listProduct;
  Uint8List? listTypeCause;

  ActionSync(
      {this.action,
        this.typea,
        this.codesource,
        this.refAudit,
        this.descpb,
        this.cause,
        this.datepa,
        this.cloture,
        this.codesite,
        this.matdeclencheur,
        this.commentaire,
        this.respsuivi,
        this.datesaisie,
        this.matOrigine,
        this.objectif,
        this.respclot,
        this.annee,
        this.refInterne,
        this.direction,
        this.process,
        this.domaine,
        this.service,
        //this.listProduct,
        this.listTypeCause});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'action' : action,
      'typea' : typea,
      'codesource' : codesource,
      'refAudit' : refAudit,
      'descpb' : descpb,
      'cause' : cause,
      'datepa' : datepa,
      'cloture' : 0,
      'codesite' : codesite,
      'matdeclencheur': SharedPreference.getMatricule().toString(),
      'commentaire' : commentaire,
      'respsuivi' : respsuivi,
      'datesaisie' : datesaisie,
      'matOrigine' : matOrigine,
      'objectif' : objectif,
      'respclot' : respclot,
      'annee' : annee,
      'refInterne' : refInterne,
      'direction' : direction,
      'process' : process,
      'domaine' : domaine,
      'service' : service,
      //'listProduct' : listProduct,
      'listTypeCause' : listTypeCause
    };
    return map;
  }

  ActionSync.fromDBLocal(Map<String, dynamic> json) {
    action = json['action'];
    typea = json['typea'];
    codesource = json['codesource'];
    refAudit = json['refAudit'];
    descpb = json['descpb'];
    cause = json['cause'];
    datepa = json['datepa'];
    cloture = json['cloture'];
    codesite = json['codesite'];
    matdeclencheur = json['matdeclencheur'];
    commentaire = json['commentaire'];
    respsuivi = json['respsuivi'];
    datesaisie = json['datesaisie'];
    matOrigine = json['matOrigine'];
    objectif = json['objectif'];
    respclot = json['respclot'];
    annee = json['annee'];
    refInterne = json['refInterne'];
    direction = json['direction'];
    process = json['process'];
    domaine = json['domaine'];
    service = json['service'];
    listTypeCause = json['listTypeCause'];

  }

}