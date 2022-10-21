class PNCValidationTraitementModel {
  int? nnc;
  String? dateDetect;
  String? produit;
  String? typeNC;
  int? qteDetect;
  String? codePdt;
  String? nc;
  String? nomClt;

  PNCValidationTraitementModel(
      {this.nnc,
        this.dateDetect,
        this.produit,
        this.typeNC,
        this.qteDetect,
        this.codePdt,
        this.nc,
        this.nomClt});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'nnc' : nnc,
      'dateDetect' : dateDetect,
      'produit' : produit,
      'typeNC' : typeNC,
      'qteDetect' : qteDetect,
      'codePdt' : codePdt,
      'nc' : nc,
      'nomClt' : nomClt,
    };
    return map;
  }
}