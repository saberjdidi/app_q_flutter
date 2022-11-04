class ActionVisiteSecurite {
  int? online;
  int? idFiche;
  int? nAct;
  String? act;

  ActionVisiteSecurite({this.online, this.idFiche, this.nAct, this.act});

  ActionVisiteSecurite.fromSQLite(Map<String, dynamic> json) {
    online = json['online'];
    idFiche = json['idFiche'];
    nAct = json['nAct'];
    act = json['act'];
  }

  Map<String, dynamic> toSQLite() {
    var map = <String, dynamic>{
      'online': online,
      'idFiche': idFiche,
      'nAct': nAct,
      'act': act,
    };
    return map;
  }

  bool isEqual(ActionVisiteSecurite? model) {
    return this.nAct == model?.nAct;
  }
}
