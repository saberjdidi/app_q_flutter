class TypeActionModel {
  int? codetypeAct;
  String? typeAct;
  int? actSimpl;
  int? analyseCause;

  TypeActionModel({this.codetypeAct, this.typeAct, this.actSimpl, this.analyseCause});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codetypeAct' : codetypeAct,
      'typeAct' : typeAct,
      'actSimpl' : actSimpl,
      'analyseCause' : analyseCause
    };
    return map;
  }

  bool isEqual(TypeActionModel? model) {
    return this.codetypeAct == model?.codetypeAct;
  }
}