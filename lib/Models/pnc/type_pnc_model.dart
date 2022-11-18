class TypePNCModel {
  int? online;
  int? nnc;
  int? idProduct;
  int? idTabNcProductType;
  int? codeTypeNC;
  String? typeNC;
  String? color;
  num? pourcentage;

  TypePNCModel(
      {this.online,
      this.nnc,
      this.idProduct,
      this.idTabNcProductType,
      this.codeTypeNC,
      this.typeNC,
      this.color,
      this.pourcentage});

  Map<String, dynamic> dataMap() {
    var map = <String, dynamic>{
      'codeTypeNC': codeTypeNC,
      'typeNC': typeNC,
      'color': color,
    };
    return map;
  }

  Map<String, dynamic> dataMapTypeProductNC() {
    var map = <String, dynamic>{
      'online': online,
      'nnc': nnc,
      'idProduct': idProduct,
      'idTabNcProductType': idTabNcProductType,
      'codeTypeNC': codeTypeNC,
      'typeNC': typeNC,
      'color': color,
      'pourcentage': pourcentage
    };
    return map;
  }

  TypePNCModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    nnc = json['nnc'];
    idProduct = json['idProduct'];
    idTabNcProductType = json['idTabNcProductType'];
    codeTypeNC = json['codeTypeNC'];
    typeNC = json['typeNC'];
    color = json['color'];
    pourcentage = json['pourcentage'];
  }

  bool isEqual(TypePNCModel? model) {
    return this.codeTypeNC == model?.codeTypeNC;
  }
}
