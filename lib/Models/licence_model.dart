import 'module_licence_model.dart';

class LicenceModel {
  String? client;
  String? licence;
  String? nbInstall;
  String? nbInstallTaken;
  String? webservice;
  String? downloadLink;
  String? deviceId;
  String? deviceName;
  String? nbDays;
  String? host;
  int? action;
  int? audit;
  int? docm;
  int? incinv;
  int? incsecu;
  int? pnc;
  int? reunion;
  int? visite;

  LicenceModel({
    this.client,
    this.licence,
    this.nbInstall,
    this.nbInstallTaken,
    this.webservice,
    this.downloadLink,
    this.deviceId,
    this.deviceName,
    this.nbDays,
    this.host,
    this.action,
    this.audit,
    this.docm,
    this.incinv,
    this.incsecu,
    this.pnc,
    this.reunion,
    this.visite,
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'client' : client,
      'licence' : licence,
      'nbInstall' : nbInstall,
      'nbInstallTaken' : nbInstallTaken,
      'webservice' : webservice,
      'downloadLink' : downloadLink,
      'host' : host,
      'nbDays' : nbDays,
      'deviceId' : deviceId,
      'deviceName' : deviceName,
      'action' : action,
      'audit' : audit,
      'docm' : docm,
      'incinv' : incinv,
      'incsecu' : incsecu,
      'pnc' : pnc,
      'reunion' : reunion,
      'visite' : visite,
    };
    return map;
  }

  LicenceModel.fromDBLocal(Map<String, dynamic> json) {
    client = json['client'];
    licence = json['licence'];
    nbInstall = json['nbInstall'];
    nbInstallTaken = json['nbInstallTaken'];
    webservice = json['webservice'];
    downloadLink = json['downloadLink'];
    host = json['host'];
    nbDays = json['nbDays'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    action = json['action'];
    audit = json['audit'];
    docm = json['docm'];
    incinv = json['incinv'];
    incsecu = json['incsecu'];
    pnc = json['pnc'];
    reunion = json['reunion'];
    visite = json['visite'];

  }


  bool isEqual(LicenceModel? model) {
    return this.licence == model?.licence;
  }
}