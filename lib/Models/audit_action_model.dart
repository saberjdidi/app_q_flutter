class AuditActionModel {
  int? idaudit;
  String? refAudit;
  String? interne;

  AuditActionModel({this.idaudit, this.refAudit, this.interne});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'idaudit' : idaudit,
      'refAudit' : refAudit,
      'interne' : interne
    };
    return map;
  }

  bool isEqual(AuditActionModel? model) {
    return this.idaudit == model?.idaudit;
  }
}