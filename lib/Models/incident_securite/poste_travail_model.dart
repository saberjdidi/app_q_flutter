class PosteTravailModel {
  String? code;
  String? poste;

  PosteTravailModel({this.code, this.poste});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'code' : code,
      'poste' : poste
    };
    return map;
  }

  bool isEqual(PosteTravailModel? model) {
    return this.code == model?.code;
  }
}