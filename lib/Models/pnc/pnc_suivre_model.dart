class PNCSuivreModel {
  int? nnc;
  String? dateDetect;
  String? produit;
  String? typeNC;
  int? qteDetect;
  int? traitee;
  String? delaiTrait;
  String? nlot;
  String? codepdt;
  int? ind;
  String? nc;
  String? nomClt;

  PNCSuivreModel(
      {this.nnc,
        this.dateDetect,
        this.produit,
        this.typeNC,
        this.qteDetect,
        this.traitee,
        this.delaiTrait,
        this.nlot,
        this.codepdt,
        this.ind,
        this.nc,
        this.nomClt});

  Map<String, dynamic> dataMapPNCInvestigationEffectuer(){
    var map = <String, dynamic>{
      'nnc' : nnc,
      'dateDetect' : dateDetect,
      'produit' : produit,
      'typeNC' : typeNC,
      'qteDetect' : qteDetect,
      //'traitee' : traitee,
      //'delaiTrait' : delaiTrait,
      'nlot' : nlot,
      'codepdt' : codepdt,
      'ind' : ind,
      'nomClt' : nomClt,
      //'nc' : nc
    };
    return map;
  }

  Map<String, dynamic> dataMapPNCInvestigationApprouver(){
    var map = <String, dynamic>{
      'nnc' : nnc,
      'dateDetect' : dateDetect,
      'produit' : produit,
      'typeNC' : typeNC,
      'qteDetect' : qteDetect,
      //'traitee' : traitee,
      //'delaiTrait' : delaiTrait,
      'nlot' : nlot,
      'codepdt' : codepdt,
      'ind' : ind,
      'nomClt' : nomClt,
      //'nc' : nc
    };
    return map;
  }

  Map<String, dynamic> dataMapPNCSuivre(){
    var map = <String, dynamic>{
      'nnc' : nnc,
      'dateDetect' : dateDetect,
      'produit' : produit,
      'typeNC' : typeNC,
      'qteDetect' : qteDetect,
      'traitee' : traitee,
      'delaiTrait' : delaiTrait,
      'nlot' : nlot,
      'codepdt' : codepdt,
      'ind' : ind,
      'nomClt' : nomClt,
      'nc' : nc
    };
    return map;
  }

  Map<String, dynamic> dataMapPNCApprobationFinale(){
    var map = <String, dynamic>{
      'nnc' : nnc,
      'dateDetect' : dateDetect,
      'produit' : produit,
      'typeNC' : typeNC,
      'qteDetect' : qteDetect,
      'nlot' : nlot,
      'codepdt' : codepdt,
      'ind' : ind,
      'nomClt' : nomClt
    };
    return map;
  }
}