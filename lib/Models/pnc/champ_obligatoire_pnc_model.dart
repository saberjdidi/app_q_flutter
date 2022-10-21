class ChampObligatoirePNCModel  {
  int? numInterne;
  int? enregistre;
  int? dateLivr;
  int? numOf;
  int? numLot;
  int? fournisseur;
  int? qteDetect;
  int? qteProduite;
  int? unite;
  int? gravite;
  int? source;
  int? atelier;
  int? origine;
  int? nonConf;
  int? traitNc;
  int? typeTrait;
  int? respTrait;
  int? delaiTrait;
  int? respSuivi;
  int? datTrait;
  int? coutTrait;
  int? quantite;
  int? valeur;
  int? rapTrait;
  int? datClo;
  int? rapClo;
  int? pourcTypenc;
  int? detectPar;

  ChampObligatoirePNCModel(
      {this.numInterne,
        this.enregistre,
        this.dateLivr,
        this.numOf,
        this.numLot,
        this.fournisseur,
        this.qteDetect,
        this.qteProduite,
        this.unite,
        this.gravite,
        this.source,
        this.atelier,
        this.origine,
        this.nonConf,
        this.traitNc,
        this.typeTrait,
        this.respTrait,
        this.delaiTrait,
        this.respSuivi,
        this.datTrait,
        this.coutTrait,
        this.quantite,
        this.valeur,
        this.rapTrait,
        this.datClo,
        this.rapClo,
        this.pourcTypenc,
        this.detectPar});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
    'numInterne' : numInterne,
    'enregistre' : enregistre,
    'dateLivr' : dateLivr,
    'numOf' : numOf,
    'numLot' : numLot,
    'fournisseur' : fournisseur,
    'qteDetect' : qteDetect,
    'qteProduite' : qteProduite,
    'unite' : unite,
    'gravite' : gravite,
    'source' : source,
    'atelier' : atelier,
    'origine' : origine,
    'nonConf' : nonConf,
    'traitNc' : traitNc,
    'typeTrait' : typeTrait,
    'respTrait' : respTrait,
    'delaiTrait' : delaiTrait,
    'respSuivi' : respSuivi,
    'datTrait' : datTrait,
    'coutTrait' : coutTrait,
    'quantite' : quantite,
    'valeur' : valeur,
    'rapTrait' : rapTrait,
    'datClo' : datClo,
    'rapClo' : rapClo,
    'pourcTypenc' : pourcTypenc,
    'detectPar' : detectPar
    };
    return map;
  }
}