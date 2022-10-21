import '../Utils/shared_preference.dart';

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
        this.service});

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
      'service' : service
    };
    return map;
  }

}