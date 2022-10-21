class SiteLesionModel {
  int? online;
  int? codeSiteLesion;
  String? siteLesion;
  int? idIncCodeSiteLesion;
  int? idIncident;

  SiteLesionModel({
    this.online,
    this.codeSiteLesion,
    this.siteLesion,
    this.idIncCodeSiteLesion,
    this.idIncident
  });

  Map<String, dynamic> dataMapSiteLesionARattacher(){
    var map = <String, dynamic>{
      'codeSiteLesion' : codeSiteLesion,
      'siteLesion' : siteLesion
    };
    return map;
  }

  Map<String, dynamic> dataMapSiteLesionRattacher(){
    var map = <String, dynamic> {
      'online' : online,
      'incident' : idIncident,
      'codeSiteLesion' : codeSiteLesion,
      'siteLesion' : siteLesion,
      'idIncCodeSiteLesion' : idIncCodeSiteLesion,
    };
    return map;
  }
  SiteLesionModel.fromDBLocal(Map<String, dynamic> json){
    online = json['online'];
    idIncident = json['incident'];
    idIncCodeSiteLesion = json['idIncCodeSiteLesion'];
    codeSiteLesion = json['codeSiteLesion'];
    siteLesion = json['siteLesion'];
  }


  bool isEqual(SiteLesionModel? model) {
    return this.codeSiteLesion == model?.codeSiteLesion;
  }
}