class FournisseurModel {
  String? raisonSociale;
  String? activite;
  String? codeFr;

  FournisseurModel(
      {this.raisonSociale,
        this.activite,
        this.codeFr
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'raisonSociale' : raisonSociale,
      'activite' : activite,
      'codeFr' : codeFr
    };
    return map;
  }

  bool isEqual(FournisseurModel? model) {
    return this.codeFr == model?.codeFr;
  }
}