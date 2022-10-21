class TypePNCModel {
  int? codeTypeNC;
  String? typeNC;
  String? color;

  TypePNCModel(
      {this.codeTypeNC,
        this.typeNC,
        this.color
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeTypeNC' : codeTypeNC,
      'typeNC' : typeNC,
      'color' : color
    };
    return map;
  }

  bool isEqual(TypePNCModel? model) {
    return this.codeTypeNC == model?.codeTypeNC;
  }
}