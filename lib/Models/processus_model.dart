class ProcessusModel {
  int? codeProcessus;
  String? processus;
  String? module;
  String? fiche;

  ProcessusModel({
    this.codeProcessus,
    this.processus,
    this.module,
    this.fiche,
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeProcessus' : codeProcessus,
      'processus' : processus,
      'module' : module,
      'fiche' : fiche
    };
    return map;
  }

  bool isEqual(ProcessusModel? model) {
    return this.codeProcessus == model?.codeProcessus;
  }
}