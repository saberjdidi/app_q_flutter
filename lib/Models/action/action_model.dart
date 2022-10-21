import '../../Utils/shared_preference.dart';

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
  //int? isd;
  //String? datsuivPrv;
  int? online;

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
        //this.isd,
        //this.datsuivPrv,
        this.online});

  ActionModel.fromJson(Map<String, dynamic> json) {
    online = 1;
    nAct = json['nAct'];
    site = json['site'];
    sourceAct = json['sourceAct'];
    typeAct = json['typeAct'];
    date = json['date'];
    cloture = json['cloture'];
    act = json['act'];
    nomOrigine = json['nom_origine'];
    respClot = json['resp_clot'];
    fSimp = json['fSimp'];
    idAudit = json['idAudit'];
    actionPlus0 = json['action_plus0'];
    actionPlus1 = json['action_plus1'];

  }


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
      //'datsuivPrv' : datsuivPrv,
      'online' : online
    };
    return map;
  }

  bool isEqual(ActionModel? model) {
    return this.nAct == model?.nAct;
  }
}