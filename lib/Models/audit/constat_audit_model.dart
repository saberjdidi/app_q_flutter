class ConstatAuditModel {
  int? online;
  String? refAudit;
  int? idAudit;
  int? nact;
  int? idCrit;
  int? ngravite;
  int? codeTypeE;
  String? gravite;
  String? typeE;
  String? mat;
  String? nomPre;
  int? prov;
  int? idEcart;
  int? pr;
  int? ps;
  String? descPb;
  String? act;
  int? typeAct;
  int? sourceAct;
  int? codeChamp;
  String? champ;
  String? delaiReal;

  ConstatAuditModel(
      {
        this.online,
        this.refAudit,
        this.idAudit,
        this.nact,
        this.idCrit,
        this.ngravite,
        this.codeTypeE,
        this.gravite,
        this.typeE,
        this.mat,
        this.nomPre,
        this.prov,
        this.idEcart,
        this.pr,
        this.ps,
        this.descPb,
        this.act,
        this.typeAct,
        this.sourceAct,
        this.codeChamp,
        this.champ,
        this.delaiReal});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'refAudit' : refAudit,
      'idAudit' : idAudit,
      'nact' : nact,
      'idCrit' : idCrit,
      'ngravite' : ngravite,
      'codeTypeE' : codeTypeE,
      'gravite' : gravite,
      'typeE' : typeE,
      'mat' : mat,
      'nomPre' : nomPre,
      'prov' : prov,
      'idEcart' : idEcart,
      'pr' : pr,
      'ps' : ps,
      'descPb' : descPb,
      'act' : act,
      'typeAct' : typeAct,
      'sourceAct' : sourceAct,
      'codeChamp' : codeChamp,
      'champ' : champ,
      'delaiReal' : delaiReal,
    };
    return map;
  }

  ConstatAuditModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    idAudit = json['idAudit'];
    refAudit = json['refAudit'];
    nact = json['nact'];
    idCrit = json['idCrit'];
    ngravite = json['ngravite'];
    codeTypeE = json['codeTypeE'];
    gravite = json['gravite'];
    typeE = json['typeE'];
    mat = json['mat'];
    nomPre = json['nomPre'];
    prov = json['prov'];
    idEcart = json['idEcart'];
    pr = json['pr'];
    ps = json['ps'];
    descPb = json['descPb'];
    act = json['act'];
    typeAct = json['typeAct'];
    sourceAct = json['sourceAct'];
    codeChamp = json['codeChamp'];
    champ = json['champ'];
    delaiReal = json['delaiReal'];
  }

  bool isEqual(ConstatAuditModel? model) {
    return this.refAudit == model?.refAudit;
  }
}