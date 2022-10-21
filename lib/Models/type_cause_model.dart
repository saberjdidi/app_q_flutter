class TypeCauseModel {
  int? online;
  int? nAct;
  int? idTypeCause;
  int? codetypecause;
  String? typecause;

  TypeCauseModel({
    this.online,
    this.nAct,
    this.idTypeCause,
    this.codetypecause,
    this.typecause
  });

  Map<String, dynamic> dataMapActionARattacher(){
    var map = <String, dynamic>{
      'codetypecause' : codetypecause,
      'typecause' : typecause
    };
    return map;
  }
  Map<String, dynamic> dataMapAction(){
    var map = <String, dynamic>{
      'online' : online,
      'nAct' : nAct,
      'idTypeCause' : idTypeCause,
      'codetypecause' : codetypecause,
      'typecause' : typecause,
    };
    return map;
  }
  Map<String, dynamic> dataMapIncidentSecurite(){
    var map = <String, dynamic>{
      'idTypeCause' : idTypeCause,
      'typeCause' : typecause
    };
    return map;
  }
  TypeCauseModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    nAct = json['nAct'];
    idTypeCause = json['idTypeCause'];
    codetypecause = json['codetypecause'];
    typecause = json['typecause'];

  }


  bool isEqual(TypeCauseModel? model) {
    return this.codetypecause == model?.codetypecause;
  }
}