class ActionIncEnv {
  int? online;
  int? idFiche;
  int? nAct;
  String? act;

  ActionIncEnv({this.online, this.idFiche, this.nAct, this.act});

  ActionIncEnv.fromSQLite(Map<String, dynamic> json) {
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

  bool isEqual(ActionIncEnv? model) {
    return this.nAct == model?.nAct;
  }
}
