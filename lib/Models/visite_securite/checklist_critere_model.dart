class CheckListCritereModel {
  int? id;
  int? idReg;
  String? lib;
  int? eval;
  String? commentaire;

  CheckListCritereModel(
      {this.id, this.idReg, this.lib, this.eval, this.commentaire});

  CheckListCritereModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idReg = json['id_Reg'];
    lib = json['lib'];
    eval = json['eval'];
    commentaire = json['commentaire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_Reg'] = this.idReg;
    data['lib'] = this.lib;
    data['eval'] = this.eval;
    data['commentaire'] = this.commentaire;
    return data;
  }
}