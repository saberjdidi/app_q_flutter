class ActionIncSec {
  int? online;
  int? idFiche;
  int? nAct;
  String? act;

  ActionIncSec({this.online, this.idFiche, this.nAct, this.act});

  ActionIncSec.fromSQLite(Map<String, dynamic> json) {
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

  bool isEqual(ActionIncSec? model) {
    return this.nAct == model?.nAct;
  }
}
