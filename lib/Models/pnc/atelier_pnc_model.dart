class AtelierPNCModel {
  int? codeAtelier;
  String? atelier;

  AtelierPNCModel({this.codeAtelier, this.atelier});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeAtelier' : codeAtelier,
      'atelier' : atelier
    };
    return map;
  }

  bool isEqual(AtelierPNCModel? model) {
    return this.codeAtelier == model?.codeAtelier;
  }
}