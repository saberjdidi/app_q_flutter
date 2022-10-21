class SourceActionModel {
  int? codeSouceAct;
  String? sourceAct;

  SourceActionModel({this.codeSouceAct, this.sourceAct});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeSouceAct' : codeSouceAct,
      'sourceAct' : sourceAct
    };
    return map;
  }

  bool isEqual(SourceActionModel? model) {
    return this.codeSouceAct == model?.codeSouceAct;
  }
}