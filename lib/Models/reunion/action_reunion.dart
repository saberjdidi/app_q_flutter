class ActionReunion {
  int? online;
  int? nReunion;
  String? decision;
  int? nAct;
  String? act;
  num? efficacite;
  num? tauxRealisation;
  int? actSimplif;

  ActionReunion(
      {this.online,
      this.nReunion,
      this.decision,
      this.nAct,
      this.act,
      this.efficacite,
      this.tauxRealisation,
      this.actSimplif});

  Map<String, dynamic> dataMapActionReunionRattacher() {
    var map = <String, dynamic>{
      'online': online,
      'nReunion': nReunion,
      'decision': decision,
      'nAct': nAct,
      'act': act,
      'efficacite': efficacite,
      'tauxRealisation': tauxRealisation,
      'actSimplif': actSimplif
    };
    return map;
  }

  ActionReunion.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    nReunion = json['nReunion'];
    decision = json['decision'];
    nAct = json['nAct'];
    act = json['act'];
    efficacite = json['efficacite'];
    tauxRealisation = json['tauxRealisation'];
    actSimplif = json['actSimplif'];
  }

  ActionReunion.fromJson(Map<String, dynamic> json) {
    nReunion = json['nReunion'];
    decision = json['decision'];
    nAct = json['nAct'];
    act = json['act'];
    efficacite = json['efficacite'];
    tauxRealisation = json['tauxRealisation'];
    actSimplif = json['act_simplif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nReunion'] = this.nReunion;
    data['decision'] = this.decision;
    data['nAct'] = this.nAct;
    data['act'] = this.act;
    data['efficacite'] = this.efficacite;
    data['tauxRealisation'] = this.tauxRealisation;
    data['act_simplif'] = this.actSimplif;
    return data;
  }

  bool isEqual(ActionReunion? model) {
    return this.nAct == model?.nAct;
  }
}
