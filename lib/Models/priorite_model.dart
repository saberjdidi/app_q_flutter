class PrioriteModel {
  int? codepriorite;
  String? priorite;

  PrioriteModel({this.codepriorite, this.priorite});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codepriorite' : codepriorite,
      'priorite' : priorite
    };
    return map;
  }

  bool isEqual(PrioriteModel? model) {
    return this.codepriorite == model?.codepriorite;
  }
}