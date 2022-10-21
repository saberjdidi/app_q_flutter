class ChampCacheModel {
  int? id;
  String? module;
  String? fiche;
  int? listOrder;
  String? nomParam;
  int? visible;

  ChampCacheModel(
      {this.id,
        this.module,
        this.fiche,
        this.listOrder,
        this.nomParam,
        this.visible});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'id' : id,
      'module' : module,
      'fiche' : fiche,
      'listOrder' : listOrder,
      'nomParam' : nomParam,
      'visible' : visible
    };
    return map;
  }
}