class EquipeModel {
  int? id;
  String? mat;
  int? affectation;

  EquipeModel({this.mat, this.affectation});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mat'] = this.mat;
    data['affectation'] = this.affectation;
    return data;
  }

  Map<String, dynamic> dataMapToSync(){
    var map = <String, dynamic>{
      'id' : id,
      'mat' : mat,
      'affectation' : affectation
    };
    return map;
  }
  EquipeModel.fromDBLocal(Map<String, dynamic> json){
    mat = json['mat'];
    affectation = json['affectation'];
  }
}