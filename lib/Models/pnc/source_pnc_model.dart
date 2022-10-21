class SourcePNCModel {
  int? codeSourceNC;
  String? sourceNC;

  SourcePNCModel({this.codeSourceNC, this.sourceNC});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeSourceNC' : codeSourceNC,
      'sourceNC' : sourceNC
    };
    return map;
  }

  bool isEqual(SourcePNCModel? model) {
    return this.codeSourceNC == model?.codeSourceNC;
  }
}