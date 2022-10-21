class TraitementDecisionModel {
  int? nnc;
  String? dateDetect;
  String? produit;
  String? typeNC;
  int? qteDetect;
  String? codepdt;
  String? nlot;
  int? ind;
  String? nc;
  String? nomClt;
  String? commentaire;

  TraitementDecisionModel(
      {this.nnc,
        this.dateDetect,
        this.produit,
        this.typeNC,
        this.qteDetect,
        this.codepdt,
        this.nlot,
        this.ind,
        this.nc,
        this.nomClt,
        this.commentaire});

  Map<String, dynamic> dataMapPNCDecision(){
    var map = <String, dynamic>{
      'nnc' : nnc,
      'dateDetect' : dateDetect,
      'produit' : produit,
      'typeNC' : typeNC,
      'qteDetect' : qteDetect,
      'nlot' : nlot,
      'codepdt' : codepdt,
      'ind' : ind,
      'nc' : nc,
      'nomClt' : nomClt,
      'commentaire' : commentaire,
    };
    return map;
  }

}