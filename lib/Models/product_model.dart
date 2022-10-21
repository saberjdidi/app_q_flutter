class ProductModel {
  int? id;
  String? codePdt;
  String? produit;
  int? prix;
  String? typeProduit;
  int? codeTypeProduit;

  ProductModel(
      {
        this.id,
        this.codePdt,
        this.produit,
        this.prix,
        this.typeProduit,
        this.codeTypeProduit});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codePdt' : codePdt,
      'produit' : produit,
      'prix' : prix,
      'typeProduit' : typeProduit,
      'codeTypeProduit' : codeTypeProduit
    };
    return map;
  }

  bool isEqual(ProductModel? model) {
    return this.codePdt == model?.codePdt;
  }
}