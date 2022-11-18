class CheckListAuditModel {
  int? online;
  String? refAudit;
  int? codeChamp;
  String? champ;
  num? tauxEval;
  num? tauxConf;
  int? nbConst;

  CheckListAuditModel(
      {this.online,
      this.refAudit,
      this.codeChamp,
      this.champ,
      this.tauxEval,
      this.tauxConf,
      this.nbConst});

  CheckListAuditModel.fromJson(Map<String, dynamic> json) {
    codeChamp = json['code_champ'];
    champ = json['champ'];
    tauxEval = json['taux_eval'];
    tauxConf = json['taux_conf'];
    nbConst = json['nb_const'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code_champ'] = this.codeChamp;
    data['champ'] = this.champ;
    data['taux_eval'] = this.tauxEval;
    data['taux_conf'] = this.tauxConf;
    data['nb_const'] = this.nbConst;
    return data;
  }

  Map<String, dynamic> dataMap() {
    var map = <String, dynamic>{
      'online': online,
      'refAudit': refAudit,
      'codeChamp': codeChamp,
      'champ': champ,
      'tauxEval': tauxEval,
      'tauxConf': tauxConf,
      'nbConst': nbConst
    };
    return map;
  }
}
