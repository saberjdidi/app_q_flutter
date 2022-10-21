class ActivityModel {
  int? codeDomaine;
  String? domaine;
  String? module;
  String? fiche;

  ActivityModel({
    this.codeDomaine,
    this.domaine,
    this.module,
    this.fiche,
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeDomaine' : codeDomaine,
      'domaine' : domaine,
      'module' : module,
      'fiche' : fiche
    };
    return map;
  }

  bool isEqual(ActivityModel? model) {
    return this.codeDomaine == model?.codeDomaine;
  }
}