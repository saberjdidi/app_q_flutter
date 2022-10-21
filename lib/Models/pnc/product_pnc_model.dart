class ProductPNCModel {
  int? online;
  int? nnc;
  int? idNCProduct;
  String? codeProduit;
  String? produit;
  String? numOf;
  String? numLot;
  int? qdetect;
  int? qprod;
  String? typeProduit;
  String? unite;
  String? typeNC;

  ProductPNCModel(
      {
        this.online,
        this.nnc,
        this.idNCProduct,
        this.codeProduit,
        this.produit,
        this.numOf,
        this.numLot,
        this.qdetect,
        this.qprod,
        this.typeProduit,
        this.unite,
        this.typeNC});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'nnc' : nnc,
      'idNCProduct' : idNCProduct,
      'codeProduit' : codeProduit,
      'produit' : produit,
      'numOf' : numOf,
      'numLot' : numLot,
      'qdetect' : qdetect,
      'qprod' : qprod,
      'typeProduit' : typeProduit,
      'unite' : unite,
     // 'typeNC' : typeNC
    };
    return map;
  }

  ProductPNCModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    nnc = json['nnc'];
    idNCProduct = json['idNCProduct'];
    codeProduit = json['codeProduit'];
    produit = json['produit'];
    numOf = json['numOf'];
    numLot = json['numLot'];
    qdetect = json['qdetect'];
    qprod = json['qprod'];
    typeProduit = json['typeProduit'];
    unite = json['unite'];

  }

  bool isEqual(ProductPNCModel? model) {
    return this.codeProduit == model?.codeProduit;
  }
}