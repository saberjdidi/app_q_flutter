class DirectionModel {
  int? codeDirection;
  String? direction;
  String? module;
  String? fiche;

  DirectionModel({
    this.codeDirection,
    this.direction,
    this.module,
    this.fiche,
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeDirection' : codeDirection,
      'direction' : direction,
      'module' : module,
      'fiche' : fiche
    };
    return map;
  }

  bool isEqual(DirectionModel? model) {
    return this.codeDirection == model?.codeDirection;
  }
}