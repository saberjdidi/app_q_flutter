class CritereChecklistAuditModel {
  int? online;
  String? refAudit;
  int? idChamp;
  int? idCrit;
  String? critere;
  int? evaluation;
  String? commentaire;

  CritereChecklistAuditModel(
      {this.online,
      this.refAudit,
      this.idChamp,
      this.idCrit,
      this.critere,
      this.evaluation,
      this.commentaire});

  CritereChecklistAuditModel.fromJson(Map<String, dynamic> json) {
    idCrit = json['id_crit'];
    critere = json['critere'];
    evaluation = json['evaluation'];
    commentaire = json['commentaire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_crit'] = this.idCrit;
    data['critere'] = this.critere;
    data['evaluation'] = this.evaluation;
    data['commentaire'] = this.commentaire;
    return data;
  }

  Map<String, dynamic> dataMap() {
    var data = <String, dynamic>{
      'online': online,
      'refAudit': refAudit,
      'idChamp': idChamp,
      'idCrit': idCrit,
      'critere': critere,
      'evaluation': evaluation,
      'commentaire': commentaire,
    };
    return data;
  }

  CritereChecklistAuditModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    refAudit = json['refAudit'];
    idChamp = json['idChamp'];
    idCrit = json['idCrit'];
    critere = json['critere'];
    evaluation = json['evaluation'];
    commentaire = json['commentaire'];
  }
}
