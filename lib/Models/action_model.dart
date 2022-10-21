import '../Utils/shared_preference.dart';

class ActionModel {
  int? nAct;
  String? site;
  String? sourceAct;
  String? typeAct;
  int? cloture;
  String? date;
  String? act;
  int? tauxEff;
  int? tauxRea;
  String? nomOrigine;
  int? respClot;
  int? fSimp;
  int? idAudit;
  String? actionPlus0;
  String? actionPlus1;
  int? isd;
  String? datsuivPrv;

  ActionModel(
      {this.nAct,
        this.site,
        this.sourceAct,
        this.typeAct,
        this.cloture,
        this.date,
        this.act,
        this.tauxEff,
        this.tauxRea,
        this.nomOrigine,
        this.respClot,
        this.fSimp,
        this.idAudit,
        this.actionPlus0,
        this.actionPlus1,
        this.isd,
        this.datsuivPrv});

  /*ActionModel.fromJson(Map<String, dynamic> json) {
    nAct = json['nAct'];
    site = json['site'];
    sourceAct = json['sourceAct'];
    typeAct = json['typeAct'];
    cloture = json['cloture'];
    date = json['date'];
    act = json['act'];
    tauxEff = json['tauxEff'];
    tauxRea = json['tauxRea'];
    nomOrigine = json['nom_origine'];
    respClot = json['resp_clot'];
    fSimp = json['fSimp'];
    idAudit = json['idAudit'];
    actionPlus0 = json['action_plus0'];
    actionPlus1 = json['action_plus1'];
    isd = json['isd'];
    datsuivPrv = json['datsuiv_prv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nAct'] = this.nAct;
    data['site'] = this.site;
    data['sourceAct'] = this.sourceAct;
    data['typeAct'] = this.typeAct;
    data['cloture'] = this.cloture;
    data['date'] = this.date;
    data['act'] = this.act;
    data['tauxEff'] = this.tauxEff;
    data['tauxRea'] = this.tauxRea;
    data['nom_origine'] = this.nomOrigine;
    data['resp_clot'] = this.respClot;
    data['fSimp'] = this.fSimp;
    data['idAudit'] = this.idAudit;
    data['action_plus0'] = this.actionPlus0;
    data['action_plus1'] = this.actionPlus1;
    data['isd'] = this.isd;
    data['datsuiv_prv'] = this.datsuivPrv;
    return data;
  } */

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'nAct' : nAct,
      'site' : site,
      'sourceAct' : sourceAct,
      'typeAct' : typeAct,
      'cloture' : cloture,
      'date' : date,
      'act' : act,
      'matdeclencheur': SharedPreference.getMatricule(),
      'nomOrigine' : nomOrigine,
      'respClot' : respClot,
      'idAudit' : idAudit,
      'actionPlus0' : actionPlus0,
      'actionPlus1' : actionPlus1,
      'datsuivPrv' : datsuivPrv
    };
    return map;
  }

  bool isEqual(ActionModel? model) {
    return this.nAct == model?.nAct;
  }
}