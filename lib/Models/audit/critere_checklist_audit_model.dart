class CritereChecklistAuditModel {
  int? idCrit;
  String? critere;
  int? evaluation;
  String? commentaire;

  CritereChecklistAuditModel(
      {this.idCrit, this.critere, this.evaluation, this.commentaire});

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
}