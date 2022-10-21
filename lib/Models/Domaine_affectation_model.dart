class DomaineAffectationModel {
  int? id;
  String? module;
  String? fiche;
  int? vSite;
  int? oSite;
  int? rSite;
  int? vProcessus;
  int? oProcessus;
  int? rProcessus;
  int? vDomaine;
  int? oDomaine;
  int? rDomaine;
  int? vDirection;
  int? oDirection;
  int? rDirection;
  int? vService;
  int? oService;
  int? rService;
  int? vEmpSite;
  int? vEmpProcessus;
  int? vEmpDomaine;
  int? vEmpDirection;
  int? vEmpService;

  DomaineAffectationModel(
      {this.id,
        this.module,
        this.fiche,
        this.vSite,
        this.oSite,
        this.rSite,
        this.vProcessus,
        this.oProcessus,
        this.rProcessus,
        this.vDomaine,
        this.oDomaine,
        this.rDomaine,
        this.vDirection,
        this.oDirection,
        this.rDirection,
        this.vService,
        this.oService,
        this.rService,
        this.vEmpSite,
        this.vEmpProcessus,
        this.vEmpDomaine,
        this.vEmpDirection,
        this.vEmpService
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'id' : id,
      'module' : module,
      'fiche' : fiche,
      'vSite' : vSite,
      'oSite' : oSite,
      'rSite' : rSite,
      'vProcessus' : vProcessus,
      'oProcessus' : oProcessus,
      'rProcessus' : rProcessus,
      'vDomaine' : vDomaine,
      'oDomaine' : oDomaine,
      'rDomaine' : rDomaine,
      'vDirection' : vDirection,
      'oDirection' : oDirection,
      'rDirection' : rDirection,
      'vService' : vService,
      'oService' : oService,
      'rService' : rService,
      'vEmpSite' : vEmpSite,
      'vEmpProcessus' : vEmpProcessus,
      'vEmpDomaine' : vEmpDomaine,
      'vEmpDirection' : vEmpDirection,
      'vEmpService' : vEmpService
    };
    return map;
  }
}