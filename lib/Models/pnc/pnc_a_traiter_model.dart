class PNCTraiterModel {
  int? nnc;
  String? dateDetect;
  String? produit;
  String? typeNC;
  int? qteDetect;
  String? codepdt;
  String? nlot;
  int? ind;
  int? traitee;
  String? dateT;
  String? dateST;
  String? nc;
  String? nomClt;
  String? traitement;
  String? typeT;

  PNCTraiterModel(
      {this.nnc,
        this.dateDetect,
        this.produit,
        this.typeNC,
        this.qteDetect,
        this.codepdt,
        this.nlot,
        this.ind,
        this.traitee,
        this.dateT,
        this.dateST,
        this.nc,
        this.nomClt,
        this.traitement,
        this.typeT});

  Map<String, dynamic> dataMapPNCATraiter(){
    var map = <String, dynamic>{
      'nnc' : nnc,
      'dateDetect' : dateDetect,
      'produit' : produit,
      'typeNC' : typeNC,
      'qteDetect' : qteDetect,
      'codepdt' : codepdt,
      'nlot' : nlot,
      'ind' : ind,
      'traitee' : traitee,
      'dateT' : dateT,
      'dateST' : dateST,
      'nc' : nc,
      'nomClt' : nomClt,
      'traitement' : traitement,
      'typeT' : typeT
    };
    return map;
  }
}