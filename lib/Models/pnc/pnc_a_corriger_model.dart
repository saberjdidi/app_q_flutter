class PNCCorrigerModel {
  int? nnc;
  String? motifRefus;
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
  String? ninterne;

  PNCCorrigerModel(
      { this.nnc,
        this.motifRefus,
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
        this.ninterne});

  Map<String, dynamic> dataMapPNCValider(){
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
      'ninterne' : ninterne
    };
    return map;
  }

  Map<String, dynamic> dataMapPNCCorriger(){
    var map = <String, dynamic>{
      'nnc' : nnc,
      'motifRefus' : motifRefus,
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
      'ninterne' : ninterne
    };
    return map;
  }

}