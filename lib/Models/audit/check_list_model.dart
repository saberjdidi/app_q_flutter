class CheckListModel {
  int? codeChamp;
  String? champ;
  num? tauxEval;
  num? tauxConf;
  int? nbConst;

  CheckListModel(
      {this.codeChamp, this.champ, this.tauxEval, this.tauxConf, this.nbConst});

  CheckListModel.fromJson(Map<String, dynamic> json) {
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
}