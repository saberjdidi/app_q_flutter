class ActionSuiteAudit {
  int? nact;
  String? act;
  int? ind;
  String? datsuivPrv;
  int? isd;

  ActionSuiteAudit({this.nact, this.act, this.ind, this.datsuivPrv, this.isd});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'nAct' : nact,
      'act' : act,
      'datsuivPrv' : datsuivPrv,
      'ind' : ind,
      'isd' : isd
    };
    return map;
  }
}