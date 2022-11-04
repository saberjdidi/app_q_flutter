class CheckListCritereModel {
  int? online;
  int? id;
  int? idFiche;
  int? idReg;
  String? lib;
  int? eval;
  String? commentaire;

  CheckListCritereModel(
      {this.online,
      this.id,
      this.idFiche,
      this.idReg,
      this.lib,
      this.eval,
      this.commentaire});

  CheckListCritereModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFiche = json['idFiche'];
    idReg = json['id_Reg'];
    lib = json['lib'];
    eval = json['eval'];
    commentaire = json['commentaire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idFiche'] = this.idFiche;
    data['id_Reg'] = this.idReg;
    data['lib'] = this.lib;
    data['eval'] = this.eval;
    data['commentaire'] = this.commentaire;
    return data;
  }

  Map<String, dynamic> dataMapVS() {
    var map = <String, dynamic>{
      'online': online,
      'id': id,
      'idFiche': idFiche,
      'idReg': idReg,
      'lib': lib,
      'eval': eval,
      'commentaire': commentaire,
    };
    return map;
  }

  CheckListCritereModel.fromSQLite(Map<String, dynamic> json) {
    online = json['online'];
    id = json['id'];
    idFiche = json['idFiche'];
    idReg = json['idReg'];
    lib = json['lib'];
    eval = json['eval'];
    commentaire = json['commentaire'];
  }
}
