import 'equipe_visite_securite_model.dart';

class VisiteSecuriteModel {
  int? online;
  int? id;
  String? site;
  String? dateVisite;
  String? unite;
  String? zone;
  String? checkList;
  int? idCheckList;
  int? idUnite;
  int? idZone;
  int? codeSite;
  String? situationObserve;
  String? comportementSurObserve;
  String? comportementRisqueObserve;
  String? correctionImmediate;
  String? autres;
  //List<EquipeVisiteSecuriteModel>? listEquipe;

  VisiteSecuriteModel(
      {
        this.online,
        this.id,
        this.site,
        this.dateVisite,
        this.unite,
        this.zone,
        this.checkList,
        this.idCheckList,
        this.idUnite,
        this.idZone,
        this.codeSite,
        this.situationObserve,
        this.comportementSurObserve,
        this.comportementRisqueObserve,
        this.correctionImmediate,
        this.autres,
        //this.listEquipe,
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'id' : id,
      'site' : site,
      'dateVisite' : dateVisite,
      'unite' : unite,
      'zone' : zone
    };
    return map;
  }

  Map<String, dynamic> dataMapSync(){
    var map = <String, dynamic>{
      'online' : online,
      'id' : id,
      'site' : site,
      'dateVisite' : dateVisite,
      'unite' : unite,
      'zone' : zone,
      'checkList' : checkList,
      'idCheckList' : idCheckList,
      'idUnite' : idUnite,
      'idZone' : idZone,
      'codeSite' : codeSite,
      'situationObserve' : situationObserve,
      'comportementSurObserve' : comportementSurObserve,
      'comportementRisqueObserve' : comportementRisqueObserve,
      'correctionImmediate' : correctionImmediate,
      'autres' : autres,
    };
    return map;
  }

  VisiteSecuriteModel.fromDBLocal(Map<String, dynamic> json){
    online = json['online'];
    id = json['id'];
    site = json['site'];
    dateVisite = json['dateVisite'];
    unite = json['unite'];
    zone = json['zone'];
    checkList = json['checkList'];
    idCheckList = json['idCheckList'];
    idUnite = json['idUnite'];
    idZone = json['idZone'];
    codeSite = json['codeSite'];
    situationObserve = json['situationObserve'];
    comportementSurObserve = json['comportementSurObserve'];
    comportementRisqueObserve = json['comportementRisqueObserve'];
    correctionImmediate = json['correctionImmediate'];
    autres = json['autres'];
  }
}