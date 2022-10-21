class TypeCausePNCModel {
  int? online;
  int? nnc;
  int? idTypeCause;
  int? codetypecause;
  String? typecause;

  TypeCausePNCModel({
    this.online,
    this.nnc,
    this.idTypeCause,
    this.codetypecause,
    this.typecause
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'nnc' : nnc,
      'idTypeCause' : idTypeCause,
      'codetypecause' : codetypecause,
      'typecause' : typecause
    };
    return map;
  }
  Map<String, dynamic> dataMapARattacher(){
    var map = <String, dynamic>{
      'codetypecause' : codetypecause,
      'typecause' : typecause
    };
    return map;
  }

  TypeCausePNCModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    nnc = json['nnc'];
    idTypeCause = json['idTypeCause'];
    codetypecause = json['codetypecause'];
    typecause = json['typecause'];

  }

  bool isEqual(TypeCausePNCModel? model) {
    return this.codetypecause == model?.codetypecause;
  }
}