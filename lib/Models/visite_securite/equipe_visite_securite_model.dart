class EquipeVisiteSecuriteModel {
  int? online;
  int? id;
  int? affectation;
  String? mat;
  String? nompre;

  EquipeVisiteSecuriteModel({this.id, this.affectation, this.mat, this.nompre});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'affectation' : affectation,
      'mat' : mat,
      'nompre' : nompre
    };
    return map;
  }

  Map<String, dynamic> dataMapOffline(){
    var map = <String, dynamic>{
      'online' : online,
      'idFiche' : id,
      'affectation' : affectation,
      'mat' : mat,
      'nompre' : nompre
    };
    return map;
  }
}