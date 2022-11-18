class AuditeurModel {
  int? code;
  int? online;
  String? mat;
  String? nompre;
  String? affectation;
  String? refAudit;

  AuditeurModel(
      {this.code,
      this.online,
      this.mat,
      this.nompre,
      this.affectation,
      this.refAudit});

  Map<String, dynamic> dataMap() {
    var map = <String, dynamic>{
      'code': code,
      'mat': mat,
      'nompre': nompre,
      'affectation': affectation
    };
    return map;
  }

  Map<String, dynamic> dataMapAuditeurInterne() {
    var map = <String, dynamic>{
      'online': online,
      'mat': mat,
      'nompre': nompre,
      'affectation': affectation,
      'refAudit': refAudit
    };
    return map;
  }

  Map<String, dynamic> dataMapAuditeurInterneARattacher() {
    var map = <String, dynamic>{
      'mat': mat,
      'nompre': nompre,
      'refAudit': refAudit
    };
    return map;
  }

  AuditeurModel.fromDBLocalAuditeurInterne(Map<String, dynamic> json) {
    online = json['online'];
    refAudit = json['refAudit'];
    mat = json['mat'];
    nompre = json['nompre'];
    affectation = json['affectation'];
  }

  Map<String, dynamic> dataMapAuditeurExterneRattacher() {
    var map = <String, dynamic>{
      'online': online,
      'organisme': mat,
      'nompre': nompre,
      'affectation': affectation,
      'refAudit': refAudit,
      'codeAuditeur': code
    };
    return map;
  }

  AuditeurModel.fromDBLocalAuditeurExterneRattacher(Map<String, dynamic> json) {
    online = json['online'];
    mat = json['organisme'];
    refAudit = json['refAudit'];
    nompre = json['nompre'];
    code = json['codeAuditeur'];
    affectation = json['affectation'];
  }
  Map<String, dynamic> dataMapAllAuditeurExterne() {
    var map = <String, dynamic>{
      'organisme': mat,
      'nompre': nompre,
      'codeAuditeur': code
    };
    return map;
  }

  Map<String, dynamic> dataMapEmployeHabiliteAudit() {
    var map = <String, dynamic>{
      'online': online,
      'mat': mat,
      'nompre': nompre,
      'refAudit': refAudit
    };
    return map;
  }

  AuditeurModel.fromDBEmployeHabiliteAudit(Map<String, dynamic> json) {
    online = json['online'];
    refAudit = json['refAudit'];
    mat = json['mat'];
    nompre = json['nompre'];
  }

  bool isEqual(AuditeurModel? model) {
    return this.mat == model?.mat;
  }
}
