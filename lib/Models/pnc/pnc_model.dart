class PNCModel {
  int? online;
  int? nnc;
  String? codePdt;
  int? codeTypeNC;
  String? dateDetect;
  String? dateLivraison;
  String? nc;
  String? unite;
  int? valRej;
  int? qteDetect;
  String? recep;
  String? traitement;
  int? ctr;
  int? ctt;
  int? traitee;
  String? respTrait;
  int? cloturee;
  String? actionIm;
  String? dateSaisie;
  String? codeFournisseur;
  String? codeClient;
  String? numInterne;
  int? qteProduct;
  String? numeroOf;
  String? numeroLot;
  String? matOrigine;
  String? isps;
  int? codeGravite;
  int? codeSource;
  int? codeSite;
  int? codeProcessus;
  int? codeDirection;
  int? codeService;
  int? codeActivity;
  int? codeAtelier;
  int? bloque;
  int? isole;
  int? etatNC;
  int? pourcentage;

  String? typeNC;
  String? produit;
  String? site;
  String? fournisseur;
  String? rapportT;

  PNCModel(
      {this.online,
        this.nnc,
        this.codePdt,
        this.codeTypeNC,
        this.dateDetect,
        this.dateLivraison,
        this.nc,
        this.unite,
        this.valRej,
        this.qteDetect,
        this.recep,
        this.traitement,
        this.ctr,
        this.ctt,
        this.traitee,
        this.respTrait,
        this.cloturee,
        this.actionIm,
        this.dateSaisie,
        this.codeFournisseur,
        this.codeClient,
        this.numInterne,
        this.qteProduct,
        this.numeroOf,
        this.numeroLot,
        this.matOrigine,
        this.isps,
        this.codeGravite,
        this.codeSource,
        this.codeSite,
        this.codeProcessus,
        this.codeDirection,
        this.codeService,
        this.codeActivity,
        this.codeAtelier,
        this.bloque,
        this.isole,
        this.etatNC,
        this.pourcentage,
        this.typeNC,
        this.produit,
        this.site,
        this.fournisseur,
        this.rapportT
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'nnc' : nnc,
      'codePdt': codePdt,
      'codeTypeNC' : codeTypeNC,
      'dateDetect' : dateDetect,
      'nc' : nc,
      'unite' : unite,
      'valRej' : valRej,
      'recep' : recep,
      'qteDetect' : qteDetect,
      'traitee' : traitee,
      'etatNC' : etatNC,
      'numInterne' : numInterne,
      'typeNC' : typeNC,
      'numeroOf' : numeroOf,
      'numeroLot' : numeroLot,
      'produit' : produit,
      'site' : site,
      'fournisseur' : fournisseur,
      'rapportT' : rapportT,
    };
    return map;
  }

  Map<String, dynamic> dataMapSync(){
    var map = <String, dynamic>{
      'online' : online,
      'nnc' : nnc,
      'codePdt': codePdt,
      'codeTypeNC' : codeTypeNC,
      'dateDetect' : dateDetect,
      'nc' : nc,
      'unite' : unite,
      'valRej' : valRej,
      'recep' : recep,
      'qteDetect' : qteDetect,
      'dateLivraison' : dateLivraison,
      'traitee' : traitee,
      'actionIm' : actionIm,
      'dateSaisie' : dateSaisie,
      'codeFournisseur': codeFournisseur,
      'codeClient' : codeClient,
      'numInterne' : numInterne,
      'qteProduct' : qteProduct,
      'numeroOf' : numeroOf,
      'numeroLot' : numeroLot,
      'matOrigine' : matOrigine,
      'isps' : isps,
      'codeGravite' : codeGravite,
      'codeSource' : codeSource,
      'codeSite' : codeSite,
      'codeProcessus' : codeProcessus,
      'codeDirection' : codeDirection,
      'codeService' : codeService,
      'codeActivity' : codeActivity,
      'codeAtelier' : codeAtelier,
      'bloque' : bloque,
      'isole' : isole,
      'pourcentage' : pourcentage,
      'typeNC' : typeNC,
      'produit' : produit,
      'site' : site,
      'fournisseur' : fournisseur,
      'rapportT' : rapportT,
    };
    return map;
  }
  PNCModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    nnc = json['nnc'];
    codePdt = json['codePdt'];
    codeTypeNC = json['codeTypeNC'];
    dateDetect = json['dateDetect'];
    nc = json['nc'];
    unite = json['unite'];
    valRej = json['valRej'];
    recep = json['recep'];
    qteDetect = json['qteDetect'];
    dateLivraison = json['dateLivraison'];
    traitee = json['traitee'];
    actionIm = json['actionIm'];
    dateSaisie = json['dateSaisie'];
    codeFournisseur = json['codeFournisseur'];
    codeClient = json['codeClient'];
    numInterne = json['numInterne'];
    qteProduct = json['qteProduct'];
    numeroOf = json['numeroOf'];
    numeroLot = json['numeroLot'];
    matOrigine = json['matOrigine'];
    isps = json['isps'];
    codeGravite = json['codeGravite'];
    codeSource = json['codeSource'];
    codeSite = json['codeSite'];
    codeProcessus = json['codeProcessus'];
    codeDirection = json['codeDirection'];
    codeService = json['codeService'];
    codeActivity = json['codeActivity'];
    codeAtelier = json['codeAtelier'];
    bloque = json['bloque'];
    isole = json['isole'];
    pourcentage = json['pourcentage'];
    typeNC = json['typeNC'];
    produit = json['produit'];
    site = json['site'];
    fournisseur = json['fournisseur'];
    rapportT = json['rapportT'];
  }
}